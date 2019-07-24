<navbar-component>
  <nav class="cyan darken-2">
    <div class="nav-wrapper">
      <img class="brand-logo right" src="images/xenon-ico.png">
      <ul class="left">
        <li>
          <div class="input-field">
            <input id="search" type="search" required placeholder="Search Document..." onkeyup={ searchData }>
            <label class="label-icon" for="search"><i class="material-icons">search</i>
            </label>
          </div>
        </li>
      </ul>
    </div>
  </nav>

  <script>
    var ipcRenderer = require('electron').ipcRenderer;

    searchData(e) {
      var q = e.target.value;
      var qr = ipcRenderer.sendSync('search-data', { query: q })
      sharedObservable.trigger('search-res', {result : qr})
    };

  </script>
</navbar-component>