library polymer_elements.polymer_localstorage;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';

/**
 * polymer-localstorage provides access to localStorage.  The "name" property
 * is the key to the data ("value" property) stored in localStorage.
 *
 * polymer-localstorage automatically saves the value to localStorage when
 * value is changed.  Note that if value is an object auto-save will be
 * triggered only when value is a different instance.
 *
 * Example:
 *
 *     <polymer-localstorage name="my-app-storage" value="{{value}}"></polymer-localstorage>
 */
@CustomTag('polymer-localstorage')
class PolymerLocalstorage extends PolymerElement {
  PolymerLocalstorage.created() : super.created();

  final _logger = new Logger('polymer-localstorage');

  /**
   * The key to the data stored in localStorage.
   */
  @published String name = '';

  /**
   * The data associated with the specified name.
   */
  @published var value;

  /**
   * If true, the value is stored and retrieved without JSON processing.
   */
  @observable bool useRaw = false;

  /**
   * If true, auto save is disabled.
   */
  @observable bool autoSaveDisabled = false;

  bool loaded = false;

  static const EventStreamProvider<CustomEvent> _loadEvent =
      const EventStreamProvider<CustomEvent>('polymer-localstorage-load');

  /**
   * Fired after it is loaded from localStorage.
   */
  Stream<CustomEvent> get onLoadEvent =>
      PolymerLocalstorage._loadEvent.forTarget(this);

  @override
  void attached() {
    super.attached();
    _logger.finest('polymer-localstorage inserted');

    // let the bindings complete, so run this async
    // TODO: should we use runAsync here?
    scheduleMicrotask(load);
  }

  valueChanged(oldValue) {
    if (this.loaded && !this.autoSaveDisabled) {
      this.save();
    }
  }

  void load() {
    var s = window.localStorage[name];
    if (s != null && !useRaw) {
      try {
        value = JSON.decode(s);
      } catch (x) {
        this.value = s;
      }
    } else {
      this.value = s;
    }
    this.loaded = true;
    dispatchEvent(new CustomEvent('polymer-localstorage-load'));
  }

  /**
   * Saves the value to localStorage.
   */
  void save() {
    window.localStorage[name] = useRaw ? value : JSON.encode(this.value);
  }
}