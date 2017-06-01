# 1. Prerequisites

Please make sure the complete the following steps as described in the article.html:

* Install Visual Studio Code [VSCode] (to `c:/VSCode`)
* Install Git + Bash and integrate with VSC (to `c:/git`)
* Install NodeJS (to `c:/nodejs`)
* Install Node Modules `tsd`, `typings` and `jslint` globally (with `-g` flag)
* Install SN-Filesync (to `sn-filesync-master`)
* Install the recommended VSC Extensions (optional, but really helpful)

Also make sure to install everything in the proposed folders as suggested in the article.

# 2. Step-by-Step (VSCode)

* Copy this folder and rename according to subdomain of `service-now.com`
* edit `sync-config.json` and replace every `xxx` within the `roots` attribute
* open Terminal (Bash) and make sure you are in the current project folder
    * prepare node modules by typing: `npm install`
    * start downloading all files of your given user from ServiceNow
        * type `sndl` (if you configured such an alias in `.bashrc`)
        * otherwise type `node /c/sn-filesync-master/bin/app.js --config ./sync-config.json --search mine --download`
* initialize a Git Repository and do a first commit (name it like `initial commit`)
   	* to get to the GIT View simply press [Ctrl+Shift+G]  (or View>Git)
* go to Terminal (Bash) and start your server before working on your project
    * **ATTENTION(!)**: Be sure to select the right Update Set on ServiceNow for your configured User.
    * type `snsrv` (if you configured such an alias in `.bashrc`)
    * otherwise type `node /c/sn-filesync-master/bin/app.js --config ./sync-config.json`
* start coding :)

# 3. Auto-Completion (VSCode)

The project template comes with a preinstalled Auto-Completion for JQuery and ServiceNow.

For further Information or infos about updates on the related Typescript Definitions, look here:

* https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/jquery
* https://github.com/bryceg/servicenow-dts

# 3.1. GlideRecord Auto-Completion (VSCode)

If you want to use GlideRecord Auto-Completion, please visit: https://github.com/meinzeugde/sn-dts.

Some of the steps from the installation are already handled within this project template.

# 4. Running background scripts from within Terminal

For more information on running background scripts from within your IDE, visit: https://github.com/matthaak/snow-runner.

After installing the module from the repository, be sure modify the prepared Shell script in the root of this project: `snbs-global.sh`.
This way you'll have an easy way of running your background script from within your project including track of all previous runs in form of a logfile.

## 4.1. Starting the Script

Run the script from a Unix-Shell with the following command: `./snbs-global.sh`

## 4.2. Suggestion on application scopes

If you like to you can create a copy of this script for different application scopes.
Therefore you should also create a different file in folder `background_scripts`.

### 4.2.1. Preventing issues with multiple Application Scopes

FYI: The app 'snow-runner' will normally create 3 files ('.org.snowlib.snow-runner...') in your project root folder.
In one of those files, the application scope will be stored. If those files exist and you try to give a different application scope to the snow-runner via the parameter `--scope`, the app will anyway use the application scope stored in the temp file.
If you like to work with multiple application scopes, these temp files have to be removed. The shell script will take care of that.