#!/usr/bin/env python3
"""
Add allowedDays field to all raid files in data-global/scripts/raids/
BOSS raids get weekends, MONSTER raids get all days
"""

import os
import re

RAIDS_DIR = "data-global/scripts/raids"

# Weekday configurations
BOSS_DAYS = '{ "Friday", "Saturday", "Sunday" }'
MONSTER_DAYS = '{ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }'

def add_allowed_days(filepath):
    """Add allowedDays field to a raid file"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Determine if BOSS or MONSTER
    is_boss = '-- Raid type: BOSS' in content
    is_monster = '-- Raid type: MONSTER' in content
    
    if not is_boss and not is_monster:
        print(f"⚠️  Skipping {os.path.basename(filepath)} - no type classification found")
        return False
    
    days = BOSS_DAYS if is_boss else MONSTER_DAYS
    raid_type = "BOSS" if is_boss else "MONSTER"
    
    # Check if allowedDays already exists
    if 'allowedDays' in content:
        print(f"⏭️  Skipping {os.path.basename(filepath)} - already has allowedDays")
        return False
    
    # Find the Raid() config block and insert allowedDays after the opening brace
    # Pattern: local raid = Raid("name", {\n
    pattern = r'(local raid = Raid\([^,]+,\s*\{)\s*\n'
    replacement = r'\1\n    allowedDays = ' + days + ',\n'
    
    new_content = re.sub(pattern, replacement, content)
    
    if new_content == content:
        print(f"❌ Failed to update {os.path.basename(filepath)} - pattern not found")
        return False
    
    # Write back
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"✅ Updated {os.path.basename(filepath)} ({raid_type})")
    return True

def main():
    if not os.path.exists(RAIDS_DIR):
        print(f"Error: {RAIDS_DIR} not found")
        return
    
    # Get all .lua files
    lua_files = [f for f in os.listdir(RAIDS_DIR) if f.endswith('.lua')]
    
    print(f"Found {len(lua_files)} raid files")
    print("-" * 60)
    
    updated_count = 0
    skipped_count = 0
    failed_count = 0
    
    for filename in sorted(lua_files):
        filepath = os.path.join(RAIDS_DIR, filename)
        result = add_allowed_days(filepath)
        
        if result:
            updated_count += 1
        elif result is False and "already has" in str(result):
            skipped_count += 1
        else:
            failed_count += 1
    
    print("-" * 60)
    print(f"✅ Updated: {updated_count}")
    print(f"⏭️  Skipped: {skipped_count}")
    print(f"❌ Failed: {failed_count}")
    print(f"📊 Total: {len(lua_files)}")

if __name__ == "__main__":
    main()
