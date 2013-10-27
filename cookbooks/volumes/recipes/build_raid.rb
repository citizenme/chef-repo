#
# Cookbook Name::       volumes
# Description::         Build a raid array of volumes as directed by node[:volumes]
# Recipe::              build_raid
# Author::              Chris Howe
#
# Copyright 2011, Infochimps
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'xfs'

#
# install mdadm immediately
#
package('mdadm'){ action :nothing }.run_action(:install)

#
# Assemble raid groups using volumes defined in node metadata -- see volumes/libraries/volumes.rb
#
Silverware.raid_groups(node).each do |rg_name, rg|

  sub_vols = sub_volumes(node, rg).values.reject{|sv| sv.device.nil? }

  Chef::Log.debug( rg.inspect )
  Chef::Log.debug( sub_vols.inspect )

  #
  # * failing on apt-get install of mdadm? Run `sudo apt-get update` and re-run chef.
  # * failing on mount of ebs volumes with "mount: Structure needs cleaning"? Run `sudo mkfs.xfs -f /dev/md1` and re-run chef.
  #

  #
  # unmount all devices tagged for that raid group
  #
  sub_vols.each do |sub_vol|
    next if sub_vol.mount_point.to_s == ''
    act = mount sub_vol.mount_point do
      device sub_vol.device
      action :nothing
    end
    act.run_action(:umount)
    act.run_action(:disable)
  end

  #
  # Create the raid array
  #
  act = mdadm(rg.device) do
    devices   sub_vols.map(&:device)
    level     0
    action    :nothing
  end
  act.run_action(:create)
  act.run_action(:assemble)

  # # Scan
  # File.open("/etc/mdadm/mdadm.conf", "a") do |f|
  #   f << "DEVICE #{parts.join(' ')}\n"
  #   f << `mdadm --examine --scan`
  # end
  #
  # bash "set read-ahead" do
  #   code      "blockdev --setra #{raid_group.read_ahead} #{raid_group.device}"
  # end

  # Chef::Log.debug([rg.formattable?, rg.ready_to_format?, rg[:formatted], `file -s #{rg.device}`].inspect)

  if rg.formattable?
    if rg.ready_to_format?
      act = bash "format #{rg.name} (#{rg.sub_volumes})" do
        user      "root"
        # Returns success iff the drive is formatted XFS.
        code      %Q{ mkfs.xfs -f #{rg.device} ; file -s #{rg.device} | grep XFS }
        not_if("file -s #{rg.device} | grep XFS")
        action(:nothing)
      end
      act.run_action(:run)
      rg.formatted!
    else
      Chef::Log.warn("Not formatting #{rg.name}. Volume is unready: (#{rg.inspect})")
    end
  end


end
