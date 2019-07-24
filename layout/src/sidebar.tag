<sidebar>

  <ul id="slide-out" class="sidenav sidenav-fixed sidebar-gradient">
    <li>
      <div class="user-view">
        <div class="background">
          <img class="responsive-img" src="images/sidenbg.jpg">
        </div>
        <img class="circle" src="images/user.png">
        <span class="white-text name">Good Day Sir</span>
        <span class="white-text email">Life without word equal dying</span>
      </div>
    </li>

    <li>
      <a href="#" class="close-side waves-effect">
        <i class="material-icons">view_list</i>
        <span>Archive List</span>
      </a>
    </li>
    <li>
      <a href="#new-archive" class="close-side waves-effect">
        <i class="material-icons">archive</i>
        <span>Create New Archive</span>
      </a>
    </li>

    <li>
      <a href="#about" class="close-side waves-effect" onclick={ about }>
        <i class="material-icons">info_outline</i>
        <span>About</span>
      </a>
    </li>
  </ul>

  <script>
    // opening about windows

    var ipcRenderer = require('electron').ipcRenderer;

    about() {
      ipcRenderer.send('req-about');
    }

  </script>

</sidebar>