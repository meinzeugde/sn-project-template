# 1. Foreword

When it comes to the every-day-life of a developer, there are many tools required to ensure productive coding!

Syntax Highlighting, Auto Completion, Refactor Functionalities, Version Control, a powerful commandline, Dark Theme, Prettify/Minify-Functionalities...just to name a few. Although Service Now is quite advanced with some of these features, mostly the feeling of coding in the browser is somehow awkward.

As a starting point i want to introduce a powerful combination of addressing most of the features mentioned above:

* Microsoft Visual Studio Code (portable)
* GIT + Bash (portable)
* ServiceNow File Syncing
* GlideRecord Auto-Completion
* Running Background Scripts from within Visual Studio Code

**Notice:** The following guide applies to Windows Users with German Keyboard setting.

**Attention:** The configuration will take about 1 hour to complete and will require some technical understanding of what is actually happening. 
I don't give explanations here, just a step-by-step solution, so please read the article at least once before start.

**Advise:** I always give proposals for the directories. If you don't want to run in further configuration with the attached project template, please just use the proposed directories.

# 2. Download

You can follow the links to get the newest version of each required software:

* [http://gareth.flowers/vscode-portable/](http://gareth.flowers/vscode-portable/)
* [https://git-scm.com/download/win](https://git-scm.com/download/win) (abort the Download Dialog and choose "**Git for Windows Portable ("thumbdrive edition")**")
* [https://nodejs.org/dist/latest/](https://nodejs.org/dist/latest/) (preferably node-vx.x.x-win-x86.zip or ...x64.zip)

# 3. Installation/Configuration

After having unpacked both Archives for VSCode and GIT to a appropriate directory (e.g. c:/vscode and c:/git), let's start...

1. Start Visual Studio Code
2. Set your preferred language by pressing [F1] and typing "Configure Language"
3. Set some important user preferences  

    1. go to "File > Preferences > Settings"
    2. in the opened "settings.json" search for `git.path`, hover over the found item and press on the pencil icon  
        -> Copy to settings  
        -> set the path to the GIT executable, e.g. `"git.path": "C:\\git\\bin\\git.exe"`
    3. in the opened "settings.json" search for `terminal.integrated.shell.windows`, hover over the found item and press on the pencil icon  
        -> Copy to settings  
        -> set the path to the Bash Terminal, that is shipped with Git,
        e.g. `"terminal.integrated.shell.windows": "C:\\git\\bin\\bash.exe"`
    4. Save your customized preferences [Ctrl+S] and restart Visual Studio Code (press [F1] and type "Reload Window")
4. Enjoy enabled GIT and Integrated Terminal with Bash [Ctrl+ö]

Unpack portable NodeJS (e.g. c:/nodejs) and set an alias within your Bash Commandline to have global access

1. Start Visual Studo Code, open Bash [Ctrl+ö] and type the following commands:
    * `touch ~/.bashrc` (creates the file if not existant)
    * `vim ~/.bashrc` (opens the file in VIM-Editor)

2. Now within the editor press [Insert] on the keyboard and edit the file as follow (you may just copy & paste):

```bash
alias npm='c:\\nodejs\\npm'  
alias node='c:\\nodejs\\node.exe'  
alias sndl='node /c/sn-filesync-master/bin/app.js --config ./sync-config.json --search mine --download'
alias snsrv='node /c/sn-filesync-master/bin/app.js --config ./sync-config.json'
alias sndts='node /c/sn-dts/bin/app.js --config ./sync-config.json'
alias snpj='git clone https://github.com/meinzeugde/sn-project-template.git'
```

You might notice some additional aliases...they are used later.

3. press [Esc] within VIM and type ":wq" + [Enter], then type the following command:
    * `source ~/.bashrc` (basically executes the file and makes all the aliases available to the Terminal's environment)

4. type the following command to test if the aliases work:
    * `npm --version`
    * `node --version`

## 3.1. Recommended Plugins for VCS

You can simply install all these plugins by opening the Extensions View [Ctrl+Shift+X] (or via "View>Extensions).

* Git History Diff
* JS-CSS-HTML Formatter
    * In a opened File just press [F1] and type "Format Document" (only works in HTML, CSS or JS)
* jslint
* JSON Tools
    * In a opened File just press [F1] and type "JSON Tools" to see all available options
* lit-it
    * In a opened File just press [F1] and type "Lit it" just one line before a function starts (preferably in JS)
* minify
    * In a opened File just press [F1] and type "Minify" to see all available options
    * To automatically Minify Files, follow these steps:
    1. go to "File > Preferences > Settings"
    2. in the opened "settings.json" search for `minify.minifyExistingOnSave`, hover over the found item and press on the pencil icon  
        -> Copy to settings and set to true
    3. Save your customized preferences [Ctrl+S]
* vscode-icons
    * Activate via File > Preferences > File Icon Theme > Select "VSCode Icons"

## 3.2. Install sn-filesync-master

This is a NodeJS Module, which allows us to retrieve files from Service Now and upload them back on save.

1. Start Visual Studo Code, open Bash [Ctrl+ö] and type the following commands:
    
    * `cd /c/`
    * `git clone https://github.com/dynamicdan/sn-filesync.git sn-filesync-master`
    * `cd sn-filesync-master`
    * `npm install`

2. It's advisable to have a look at the project and try to understand what's happening: [https://github.com/dynamicdan/sn-filesync/blob/master/README.md](https://github.com/dynamicdan/sn-filesync/blob/master/README.md). You can skip the installation though, because we did it already.

3. For later usage we will utilize a command which we already configured within ~/.bashrc in **3. Installation/Configuration**.

4. Complete the following steps to fix a Bug with Visual Studio Code...

### 3.2.1. Bug/Workaround

There seems to be a file sync issue: In some cases when saving the file in VS-Code, the changes are not uploaded to SNOW, but rather the last SNOW version is downloaded to your file system, reverting all your changes.
The issue was hard to track down, but i found an explanation: Atomic Save. VS-Code doesn't simply overwrite the file when saving, it creates a duplicate tmp file, then removes the last version and renames the tmp file.

In general, File Watchers seem to have issues with this approach.

I created a little Hack to prevent this issue...

Just edit the file "C:\sn-filesync-master\bin\app.js" and go to line 1421 (as of Version 4.2.4) or search for "function onChange(file, stats) {".

Replace the onChange function like this (please do a Backup of the original app.js, just in case):

```js
function onChange(file, stats) {
    if (stats.size == 0 || fileHasErrors(file)) {
		logit.error('Failed to sync file, please try to save again.', file);
        return false;
    }
    //if (stats.size > 0) {
        logit.info('Potentially syncing changed file to instance', file, '(Size ' + stats.size + ')');
        send(file);
    //} else {
        //logit.info('Syncing empty file from instance', file);
        //receive(file, function (complete) {});
    //}
}
```

You may notice that i just commented out some lines.

# 3.3. Install snow-runner

This is a NodeJS Module, which allows us to run background scripts in Service NOw from within Visual Studio Code's Terminal.

1. Start Visual Studo Code, open Bash [Ctrl+ö] and type the following commands:
    
    * `cd /c/`
    * `git clone https://github.com/matthaak/snow-runner.git snow-runner`
    * `cd snow-runner`
    * `npm install`

2. It's advisable to have a look at the project and try to understand what's happening: [https://github.com/matthaak/snow-runner/blob/master/README.md](https://github.com/matthaak/snow-runner/blob/master/README.md). You can skip the installation though, because we did it already.

3. For later usage we will utilize a basic shell script, which is part of every single project. Refer to **4. Working with projects**

# 3.4. Install sn-dts

This is a NodeJS Module, which allows us to retrieve Type Definitions for Javascript to have Auto-Completion for instantiated GlideRecord tables.

1. Start Visual Studo Code, open Bash [Ctrl+ö] and type the following commands:
    
    * `cd /c/`
    * `git clone https://github.com/meinzeugde/sn-dts.git sn-dts`
    * `cd sn-dts`
    * `npm install`

2. It's advisable to have a look at the project and try to understand what's happening: [https://github.com/meinzeugde/sn-dts/blob/master/README.md](https://github.com/meinzeugde/sn-dts/blob/master/README.md). You can skip the installation though, because we did it already.

3. For later usage we will utilize a command which we already configured within ~/.bashrc in **3. Installation/Configuration**.

# 4. Working with projects

# 4.1. Initializing a project

1. Create a folder, where you put all your further SNOW projects in, e.g. "c:/sn_dev". You only need to to this once.

2. Start Visual Studo Code, open Bash [Ctrl+ö] and type the following commands:
    
    * `cd /c/sn_dev/`
    * `snpj <yourProjectName>` -> instead of `<yourProjectName>` use the instance prefix of your instance, e.g. "dev12345"
    * `cd <yourProjectName>`
    * `npm install`

3. Open the project folder `<yourProjectName>` in Visual Studio Code via "File>Open Folder..."

4. Edit `sync-config.json`, seek for the `roots` attribute and fill in Project Folder, Instance Prefix and Credentials, e.g.:

```json
"roots": {
    "c:/sn_dev/<yourProjectName>": {
        "host": "<yourInstancePrefix>.service-now.com",
        "user": "<yourUsername>",
        "pass": "<yourPassword>"
    }
}
```

5. Start downloading all files of your given user from ServiceNow by typing `sndl` into Terminal. You might notice that the `sync-config.json` credentials you just filled gets replaced by an Authentication Key, e.g.:

```json
"roots": {
    "c:/sn_dev/<yourProjectName>": {
        "host": "<yourInstancePrefix>.service-now.com",
        "auth": "<someAuthKey>"
    }
},
```

6. OPTIONAL: Edit `snbs-global.sh`, seek for `INSTANCE_AUTH` and `INSTANCE_NAME` variables and fill in Authentication Key and Instance Prefix, e.g.:

```sh
INSTANCE_AUTH=<someAuthKey>
INSTANCE_NAME=<yourInstancePrefix>
```

7. OPTIONAL: Test Background Script by typing `./snbs-global.sh` into Terminal. It should create a new file `snbs-global.log` and output `[DEBUG] Hello World!` in Terminal.

8. OPTIONAL: Test Type Definition Download by typing `sndts` into Terminal. It should create 3 new files within directory `typings/servicenow-dts/GlideRecord`:

    * core_company.d.ts
    * incident.d.ts
    * sys_user.d.ts

    You can configure those tables any time by editing `sync-config.json` and seek for `tables`, e.g.:

    ```json
    "tables": [
        "sys_user",
        "core_company",
        "incident"
    ],
    ```

9. OPTIONAL: Within Visual Studio Code, initialize a Git Repository and do a first commit (name it like `initial commit`) by going to "View > SCM" [Ctrl+Shift+G].

# 4.2. Daily work

If you initialized a project properly and also configured your Visual Studio Code, you might utilize the following workflow/advices:

* Open ServiceNow in your Browser, log in with the same credentials you configured in `sync-config.json` and be sure to select the right Update Set on ServiceNow for your configured User.

* Download files that were created or updated by your configured user by typing `sndl` into Terminal.

* Utilize GIT to see changes (View > SCM). Periodically commit Changes to have a local versioning of files and therefore an overview about those changes.

* Start the sn-filesync server by typing `snsrv` into terminal and let it run. Each time you save a file locally, the changes will get uploaded to ServiceNow. Stop the server by Pressing [Ctrl+c] in Terminal if you don't need to make changes on any file anymore.

* If you need Auto-Completion for specific GlideRecord tables, just type `sndts` into Terminal. This will download the appropriate Type Definitions. If necessary, add tables to `sync-config.json` (refer to Bullet Point 8 in **4.1. Initializing a project**).

* If you want to run Background Scripts, just edit the file `background_scripts/global.js` and type `./snbs-global.sh` into Terminal. This runs the script in Global Scope per Default. This is customizable via editing the Shell Script (requires some Understanding of Linux Shell Scripts).

# 5. Further Links

* [https://code.visualstudio.com/docs](https://code.visualstudio.com/docs)
* [https://code.visualstudio.com/docs/editor/whyvscode](https://code.visualstudio.com/docs/editor/whyvscode)
* [https://git-scm.com/doc](https://git-scm.com/doc)
* [https://github.com/dynamicdan/sn-filesync](https://github.com/dynamicdan/sn-filesync)
* [https://github.com/matthaak/snow-runner](https://github.com/matthaak/snow-runner)
* [https://github.com/meinzeugde/sn-dts](https://github.com/meinzeugde/sn-dts)
* [https://github.com/meinzeugde/sn-project-template](https://github.com/meinzeugde/sn-project-template)