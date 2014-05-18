library bs_modal_dialog;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('bs-modal-dialog')
class BSModalDialog extends PolymerElement {

  @published bool closable = false;
  @published String bsPanelClass = "panel-default";

  BSModalDialog.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("BSModalDialog::enteredView()");
  }

  void close([Event event, var detail, Element target]) {
    fire("close");
  }
}

