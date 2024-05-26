// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"


require('jquery')
require("@nathanvda/cocoon")

import "jquery";
import "popper.js";
import "bootstrap";
import "jquery-jscroll"
import "../stylesheets/application";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// 無限スクロールの処理
var jscrollOption = {
    loadingHtml: '読み込み中・・・', //記事読み込み中の表示
    autoTrigger: true, // 自動で読み込むか否か、trueで自動、falseでボタンクリックとなる。
    padding: 20, // 指定したコンテンツの下かた何pxで読み込むかを指定(autoTrigger: trueの場合のみ)
     nextSelector: '.next a',
    contentSelector: '.jscroll' // 読み込む範囲の指定

};
$(document).on('turbolinks:load', function() {
  $('.jscroll').jscroll(jscrollOption);}
);
