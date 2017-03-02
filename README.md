# 1. Knowledge Base

* https://solidservision.service-now.com/kb_view.do?sysparm_article=KB0010593

Please make sure the complete the following steps as described in the article:

* Install Visual Studio Code (to `c:/VSCode`)
* Install Git + Bash and integrate with VSC (to `c:/git`)
* Install NodeJS (to `c:/nodejs`)
* Install Node Modules `tsd`, `typings` and `jslint` globally (with `-g` flag)
* Install SN-Filesync (to `sn-filesync-master`)
* Install the recommended Extensions (optional, but really helpful)

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

# 3. Auto-Completion

The project template comes with a preinstalled Auto-Completion for JQuery and ServiceNow.

If you want to use GlideRecord Auto-Completion, please visit: https://github.com/meinzeugde/sn-dts.

For further Information or infos about updates on the related Typescript Definitions, look here:

* https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/jquery
* https://github.com/bryceg/servicenow-dts