<create-archive>
  <div class="row">
    <div class="col s12">
      <hideable-form if={ !is_saving }>
        <form ref="inputData" class="col s12" onsubmit={ saveData }>
          <div class="row">

            <div class="input-field col s6">
              <input ref="docNumber" id="doc-number" type="text" class="validate" required>
              <label for="doc-number">Document Number</label>
              <span class="helper-text" data-error="please input document number" data-success="">document number E.g. 120/K</span>
            </div>

            <div class="input-field col s6">
              <input ref="issuedDocNumber" id="issueddoc-number" type="text" class="validate" required>
              <label for="issueddoc-number">Issued Document Number</label>
              <span class="helper-text" data-error="please input document number" data-success="">issued document number E.g. 120/K</span>
            </div>

            <div class="input-field col s6">
              <input ref = "sendedDate" id="accepted-date" type="text" class="datepicker validate" required>
              <label for="accepted-date">Sended Date</label>
              <span class="helper-text" data-error="please insert accepted date" data-success="">document accepted date E.g 12-02-2014 (Indonesian Date)</span>
            </div>

            <div class="input-field col s6">
              <input ref="documentDate" id="document-date" type="text" class="datepicker validate" required>
              <label for="document-date">Document Date</label>
              <span class="helper-text" data-error="please insert document date" data-success="">document created date E.g E.g 02-02-2014 (Indonesian Date)</span>
            </div>

            <div class="col s6">
              <div class="chips chips-placeholder">
                <input class="custom-class">
              </div>
            </div>

            <div class="col s6">
              <div class="file-field input-field">
                <div class="file-path-wrapper">
                  <input class="file-path validate" required type="text" placeholder="click select attachment file">
                  <span class="helper-text" data-error="please insert document attachment" data-success="">only accepted pdf file if available</span>
                  <input required ref="attachmentFile" id="select-file" type="file" accept="application/pdf">
                </div>
              </div>
            </div>

            <div class="input-field col s12">
              <textarea ref="archiveSub" id="archive-subject" class="materialize-textarea validate" required></textarea>
              <label for="archive-subject">Subject</label>
              <span class="helper-text" data-error="please insert document subject for easiness" data-success="">archive subject</span>
            </div>

          </div>

          <div class="center-align">
            <button class="btn waves-effect waves-light" type="submit">
              <span>Save</span>
              <i class="material-icons right">save</i>
            </button>
          </div>

        </form>
      </hideable-form>

      <hideable-preloader if={ is_saving }>
        <div class="col s12">

          <loader-object>
            <div class="preloader-wrapper active">
              <div class="spinner-layer spinner-blue">
                <div class="circle-clipper left">
                  <div class="circle"></div>
                </div><div class="gap-patch">
                  <div class="circle"></div>
                </div><div class="circle-clipper right">
                  <div class="circle"></div>
                </div>
              </div>

              <div class="spinner-layer spinner-red">
                <div class="circle-clipper left">
                  <div class="circle"></div>
                </div><div class="gap-patch">
                  <div class="circle"></div>
                </div><div class="circle-clipper right">
                  <div class="circle"></div>
                </div>
              </div>

              <div class="spinner-layer spinner-yellow">
                <div class="circle-clipper left">
                  <div class="circle"></div>
                </div><div class="gap-patch">
                  <div class="circle"></div>
                </div><div class="circle-clipper right">
                  <div class="circle"></div>
                </div>
              </div>

              <div class="spinner-layer spinner-green">
                <div class="circle-clipper left">
                  <div class="circle"></div>
                </div><div class="gap-patch">
                  <div class="circle"></div>
                </div><div class="circle-clipper right">
                  <div class="circle"></div>
                </div>
              </div>
            </div>
            <div>Saving data...</div>
          </loader-object>

        </div>
      </hideable-preloader>

    </div>
  </div>

  <script>
    var ipcRenderer = require('electron').ipcRenderer;

    initUI() {
      // Materializecss initializer
      var datepick = document.querySelectorAll(".datepicker");
      M.Datepicker.init(datepick, {
        format: "dd-mm-yyyy",
        defaultDate: new Date()
      });

      var chips = document.querySelectorAll(".chips");

      M.Chips.init(chips, {
        placeholder: 'Add Recipient',
        secondaryPlaceholder: 'Add More',
      });
    }

    formValueStats(e) {
      if (e.target.value) {
        this.not_empty = true
      }else{
        this.not_empty = false
      }
    }

    this.on("mount", function() {
      this.initUI();
    })

    this.on("updated", function() {
      this.initUI();
    })


    saveData(e) {
      e.preventDefault()
      this.is_saving = true;

      var chipMat = document.querySelector('.chips');
      var recipientList = M.Chips.getInstance(chipMat);

      var recipienListParsed = [];

      for (x in recipientList.chipsData) {
        recipienListParsed.push(recipientList.chipsData[x].tag);
      }

      var wrapper = {
        archiveAttachment: {
          filename : this.refs.attachmentFile.files[0].name,
          path: this.refs.attachmentFile.files[0].path,
          type: this.refs.attachmentFile.files[0].type,
        },
        issuedDocNumber: this.refs.issuedDocNumber.value,
        documentDate: this.refs.documentDate.value,
        sendedDate: this.refs.sendedDate.value,
        archiveSub: this.refs.archiveSub.value,
        docNumber: this.refs.docNumber.value,
        recipient: recipienListParsed,
      }

      var encodedData = JSON.stringify(wrapper)

      ipcRenderer.send('save-Data', encodedData);
      ipcRenderer.on('sd-Replay', function(event, args) {
        Snackbar.show({
          text: '<span>Saving Done</span> <i class="em em-grin"></i>',
          pos: 'bottom-right',
          customClass : "snackbar-dspcs",
          showAction: false,
          backgroundColor: "#468189"
        });
        this.update({is_saving: false});
      }.bind(this))
    }

  </script>
</create-archive>