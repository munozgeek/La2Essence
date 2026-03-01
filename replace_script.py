import os
import re

skill_dir = r"c:\L2\La2Essence\game\data\stats\skills"
updated_files = 0

for file_name in os.listdir(skill_dir):
    if not file_name.endswith(".xml"): continue
    path = os.path.join(skill_dir, file_name)
    
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()
        
    if "<itemConsumeId>3031</itemConsumeId>" not in content:
        continue
        
    def replace_skill(match):
        skill_text = match.group(0)
        if "<itemConsumeId>3031</itemConsumeId>" in skill_text:
            # Replace itemConsumeCount completely, keeping indentation if possible
            # To be safe with indentation, we could capture the leading whitespace
            # but a simple replace is fine since it's just one line.
            # We'll use a regex that matches from <itemConsumeCount> to </itemConsumeCount>
            skill_text = re.sub(r"(?s)<itemConsumeCount>.*?</itemConsumeCount>", "<itemConsumeCount>0</itemConsumeCount>", skill_text)
        return skill_text

    new_content = re.sub(r"(?s)<skill\b.*?</skill>", replace_skill, content)
    
    if new_content != content:
        with open(path, "w", encoding="utf-8") as f:
            f.write(new_content)
        updated_files += 1
        print(f"Updated {file_name}")

print(f"Total files updated: {updated_files}")
