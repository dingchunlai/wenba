﻿/*
Copyright (c) 2003-2009, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function(){var a={elements:{$:function(b,c){var d=b.attributes._cke_realelement;realFragment=d&&new CKEDITOR.htmlParser.fragment.fromHtml(decodeURIComponent(d),c),realElement=realFragment&&realFragment.children[0];if(realElement){var e=b.attributes.style;if(e){var f=/(?:^|\s)width\s*:\s*(\d+)/.exec(e),g=f&&f[1];f=/(?:^|\s)height\s*:\s*(\d+)/.exec(e);var h=f&&f[1];if(g)realElement.attributes.width=g;if(h)realElement.attributes.height=h;}}return realElement;}}};CKEDITOR.plugins.add('fakeobjects',{requires:['htmlwriter'],afterInit:function(b){var c=b.dataProcessor,d=c&&c.htmlFilter;if(d)d.addRules(a);}});})();CKEDITOR.editor.prototype.createFakeElement=function(a,b,c,d){var e={'class':b,src:CKEDITOR.getUrl('images/spacer.gif'),_cke_realelement:encodeURIComponent(a.getOuterHtml())};if(c)e._cke_real_element_type=c;if(d)e._cke_resizable=d;return this.document.createElement('img',{attributes:e});};CKEDITOR.editor.prototype.createFakeParserElement=function(a,b,c,d){var e=new CKEDITOR.htmlParser.basicWriter();a.writeHtml(e);var f=e.getHtml(),g={'class':b,src:CKEDITOR.getUrl('images/spacer.gif'),_cke_realelement:encodeURIComponent(f)};if(c)g._cke_real_element_type=c;if(d)g._cke_resizable=d;return new CKEDITOR.htmlParser.element('img',g);};CKEDITOR.editor.prototype.restoreRealElement=function(a){var b=decodeURIComponent(a.getAttribute('_cke_realelement'));return CKEDITOR.dom.element.createFromHtml(b,this.document);};
