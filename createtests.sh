#!/bin/bash

# reset the repo
git reset --hard HEAD;git clean -d -f .

# set variables
projectName="testProject"
sourcePath="$projectName/force-app/main/default/classes"
testSourcePath="$projectName/force-app/test/default/classes"

# create the path for our classes & tests
mkdir -p $sourcePath
mkdir -p $testSourcePath

# create a sfdx project
sfdx force:project:create -n $projectName

counter=1
while [ $counter -le 10 ]
do

  echo "Running $counter"

  classTemplate="classTemplate$counter"
  classTemplateMethod="classTemplateMethod$counter"
  testTemplate="testTemplate$counter"
  testTemplateMethod="testTemplateMethod$counter"


  classTemplateFile=`cat classTemplate.cls`
  classTemplateFileMetadata=`cat classTemplate.cls-meta.xml`
  testTemplateFile=`cat testTemplate.cls`
  testTemplateFileMetadata=`cat testTemplate.cls-meta.xml`

  # update classTemplate.cls
  classTemplateFile=${classTemplateFile//$"{{classTemplate}}"/$classTemplate}

  # update classTemplate.cls-meta.xml
  classTemplateFileMetadata=${classTemplateFileMetadata//$"{{classTemplate}}"/$classTemplate}

  # update testTemplate.cls
  testTemplateFile=${testTemplateFile//$"{{testTemplate}}"/$testTemplate}
  testTemplateFile=${testTemplateFile//$"{{classTemplate}}"/$classTemplate}

  # update testTemplate.cls-meta.xml
  testTemplateFileMetadata=${testTemplateFileMetadata//$"{{testTemplate}}"/$testTemplate}

  # create files
  echo "$classTemplateFile" > "$sourcePath"/"$classTemplate".cls
  echo "$classTemplateFileMetadata" > "$sourcePath"/"$classTemplate".cls-meta.xml
  echo "$testTemplateFile" > "$testSourcePath"/"$testTemplate".cls
  echo "$testTemplateFileMetadata" > "$testSourcePath"/"$testTemplate".cls-meta.xml

  ((counter++))
done

cd $projectName

sfdx force:org:create -s -f config/project-scratch-def.json
sfdx force:source:push
sfdx force:apex:test:run -r human

echo "Complete"