<content>
  <router>
    <route path=""><archive-list></archive-list></route>
    <route path="new-archive"><create-archive></create-archive></route>
    <route path="user-setting"><user-setting></user-setting></route>
    <route path="print-doc"><document-print></document-print></route>
  </router>

  <script>

    var ipcRenderer = require('electron').ipcRenderer;

    this.on('before-mount', function() {
      ipcRenderer.send('load-Storage', {status: "stgl-ready"});
    })

  </script>
</content>