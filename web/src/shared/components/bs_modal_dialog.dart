library bs_modal_dialog;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('bs-modal-dialog')
class BSModalDialog extends PolymerElement {

  static const CLASS_NAME = "BSModalDialog";

  @published bool closable = false;
  @published String bsPanelClass = "panel-default";

  BSModalDialog.created() : super.created();

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached()");
  }

  void close([Event event, var detail, Element target]) {
    fire("close");
  }
}

