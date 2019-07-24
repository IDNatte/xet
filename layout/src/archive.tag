<archive-list>

  <div  class="row">
    
    <div class="col s12">

      <table class="striped centered responsive-table">
        <thead>
          <tr>
              <th>Document Date</th>
              <th>Sended Date</th>
              <th>Document Number</th>
              <th>Issued Number</th>
              <th>Document Subject</th>
              <th>Recipment</th>
              <th>Attachment</th>
          </tr>
        </thead>

        <tbody>
          <tr each={ data }>
            <td>{ documentDate }</td>
            <td>{ sendedDate }</td>
            <td>{ docNumber }</td>
            <td>{ issuedDocNumber }</td>
            <td>{ archiveSub }</td>
            <td>
              <recipment each={ value, name  in recipient }>
                <div class="chip">
                  { value }
                </div>
              </recipment>
            </td>
            <td>
              <a class="waves-effect waves-dark btn-flat" onclick={ openPDFfile.bind(this, archiveAttachment.path) }>
                <i class="material-icons">visibility</i>
              </a>
            </td>
          </tr>
        </tbody>
      </table>

    </div>
  </div>

  <script>

    var ipcRenderer = require('electron').ipcRenderer;

    this.on('mount', function() {
      var d = ipcRenderer.sendSync('get-data');
      this.update({data : d});
    })

    sharedObservable.on('search-res', function(args) {
      this.update({data: args.result});
    }.bind(this))

    openPDFfile(args) {
      var file = args
      ipcRenderer.send('open-pdf', file);
    }

  </script>
</archive-list>