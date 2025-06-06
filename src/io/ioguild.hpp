////////////////////////////////////////////////////////////////////////
// Crystal Server - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////

#pragma once

class Guild;
using GuildWarVector = std::vector<uint32_t>;

class IOGuild {
public:
	static std::shared_ptr<Guild> loadGuild(uint32_t guildId);
	static void saveGuild(const std::shared_ptr<Guild> &guild);
	static uint32_t getGuildIdByName(const std::string &name);
	static void getWarList(uint32_t guildId, GuildWarVector &guildWarVector);
};
