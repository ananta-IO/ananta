/*
 * jQuery File Upload Plugin JS Example 6.0
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */
/*jslint nomen: true, unparam: true, regexp: true */
/*global $, window, document */
$(function(){"use strict",$("#fileupload").fileupload(),window.location.hostname==="blueimp.github.com"?($("#fileupload").prop("action","//jquery-file-upload.appspot.com"),$("#fileupload").fileupload("option",{maxFileSize:5e6,acceptFileTypes:/(\.|\/)(gif|jpe?g|png)$/i})):$.getJSON($("#fileupload").prop("action"),function(a){var b=$("#fileupload").data("fileupload"),c;b._adjustMaxNumberOfFiles(-a.length),c=b._renderDownload(a).appendTo($("#fileupload .files")),b._reflow=b._transition&&c.length&&c[0].offsetWidth,c.addClass("in")});var a=window.location.href.replace(/\/[^\/]*$/,"/result.html?%s");$("#fileupload").bind("fileuploadsend",function(b,c){if(c.dataType.substr(0,6)==="iframe"){var d=$("<a/>").prop("href",c.url)[0];window.location.host!==d.host&&c.formData.push({name:"redirect",value:a})}}),$("#fileupload .files").delegate("a:not([rel^=gallery])","click",function(a){a.preventDefault(),$('<iframe style="display:none;"></iframe>').prop("src",this.href).appendTo(document.body)}),$("#fileupload .files").imagegallery()});