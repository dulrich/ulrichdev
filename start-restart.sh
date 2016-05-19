#!/bin/bash

# ulrichdev: A minimal web/blog server in coffeescript. Experimental.
# Copyright (C) 2014 - 2015  David Ulrich (http://github.com/dulrich)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

path=$(pwd)
prgm=server.js

running=`forever list | grep "$path/$prgm"`

cmd=restart
if [ ${#running} == 0 ]; then
	cmd=start
fi

forever $cmd $path/$prgm
