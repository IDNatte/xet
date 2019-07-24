const { dialog, ipcMain, app, BrowserWindow, webContents } = require('electron');
const { autoUpdater } = require('electron-updater');
const exfs = require("fs-extra");
const loki = require("lokijs");
const path = require('path');
const url = require('url');
const os = require('os');

const RCMenu = require('electron').Menu;
const RCMenuItem = require('electron').MenuItem;

let entryPoint = path.join(os.homedir(), 'Documents/Xenon/datastore/') ;
let about
let col
let win
let db

// function for main windows stuff
function createWindow () {

  win = new BrowserWindow({
    width: 1280,
    height: 680,
    minHeight: 768,
    minWidth: 1024
  })

  win.loadURL(url.format({
    pathname: path.join(__dirname, 'layout/index.html'),
    protocol: 'file:',
    slashes: true
  }))
  
  win.on('closed', () => {
    win = null
  })
}

function openPDF(path) {
  const pmw = new BrowserWindow({
    parent: win,
    modal: true,
    maximizable: false,
    width: 800,
    height: 450,
    webPreferences: {
      plugins: true
    }
  })

  pmw.loadURL(path);
}


// main application listener stuff
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('ready', () => {
  createWindow();

  exfs.ensureDirSync(entryPoint);
  exfs.ensureDirSync(path.join(entryPoint, 'attachment/'));

})

app.on('activate', () => {
  if (win === null) {
    createWindow()
  }
})

// renderer listener stuff
ipcMain.on('load-Storage', (event, args) => {

  let mountStat = args.status;

  if (mountStat === "stgl-ready") {
    let cdbFile = path.join(entryPoint, 'archive.json');
    exfs.ensureFile(cdbFile).then(() => {
      db = new loki(cdbFile);
  
      db.loadDatabase({}, () => {
        _col = db.getCollection('archiveCollection');
        if (_col) {
          col = _col;
        }else {
          col = db.addCollection('archiveCollection');
        }
      });
  
    })
  }
})

ipcMain.on('get-data', (event) => {
  event.returnValue = col.data
})

ipcMain.on('open-pdf', function(e, args) {
  let path = args
  openPDF(path);
})

ipcMain.on('search-data', (event, args) => {
  let r = col.find({
    '$or':[
      {
        'documentDate': {
          '$containsAny': args.query
        }
      },
      {
        'archiveSub': {
          '$containsAny': args.query
        }
      },
      {
        'recipient': {
          '$containsAny': args.query
        }
      },
      {
        'acceptedDate': {
          '$containsAny': args.query
        }
      },
      {
        'issuedDocNumber': {
          '$containsAny': args.query
        }
      }
    ]
  });

  event.returnValue = r
})

ipcMain.on('save-Data', (event, args) => {

  let saveThis = JSON.parse(args);
  let time = new Date()
  let currentTime = `${time.getHours()}-${time.getMinutes()}-${time.getSeconds()}`
  let copyMe = saveThis.archiveAttachment.path;
  let renameFormat = `${saveThis.documentDate} ${currentTime}`;

  let copyPathAttachmentFileName = path.join(entryPoint, `attachment/${renameFormat}.pdf`);

  exfs.copy(copyMe, copyPathAttachmentFileName).then(() => {

    let saveDBDataWrapper = {
      archiveAttachment: {
        path : copyPathAttachmentFileName,
        type: saveThis.archiveAttachment.type
      },
      documentDate: saveThis.documentDate,
      docNumber: saveThis.docNumber,
      sendedDate: saveThis.sendedDate,
      archiveSub: saveThis.archiveSub,
      recipient: saveThis.recipient,
      issuedDocNumber: saveThis.issuedDocNumber

    };

    if (db && col) {
      col.insert(saveDBDataWrapper);
      db.saveDatabase(() => {
        let initData = col.data;
        event.sender.send('sd-Replay', {status : 'done'});
        event.sender.send('data-send', initData);
      })
    }else {
      event.sender.send('sd-Replay', {status : 'error'});
    }
  })
})

ipcMain.on('req-about', (event, args) => {

  about = new BrowserWindow({
    parent: win,
    modal: true,
    maximizable: false,
    width: 400,
    height: 430,
    show: false,
    frame: false,
  })

  about.loadURL(url.format({
    pathname: path.join(__dirname, 'layout/about.html'),
    protocol: 'file:',
    slashes: true
  }))

  about.on('ready-to-show', () => {
    about.show()
  })

  about.on('close', () => {
    about = null
  })

})

ipcMain.on('update-op', (event, args) => {
  // autoUpdater.checkForUpdates()
  autoUpdater.checkForUpdates()
  // console.log('re-calling update event...')
})


// autoupdater listener stuff
autoUpdater.on('error', () => {
  about.webContents.send('upreslt', {status: 'error', message: 'Update error'});      
})

autoUpdater.on('checking-for-update', () => {
  about.webContents.send('upreslt', {status: 'updating', message: 'Checking update...'})
})

autoUpdater.on('download-progress', (progress) => {
  let fixedPercent = parseFloat(progress.percent).toFixed(1);
  about.webContents.send('upreslt', {status: 'downloading', message: `Downloading Update... ${fixedPercent}%`})
})

autoUpdater.on('update-downloaded', () => {
  about.webContents.send('upreslt', {status: 'installing', message: `Installing Update...`})
  autoUpdater.quitAndInstall(true, true);
})

autoUpdater.on('update-not-available', () => {
  about.webContents.send('upreslt', {status: 'noupdate', message: 'Latest Version'})
})
