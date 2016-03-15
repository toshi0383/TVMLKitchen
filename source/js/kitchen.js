/*
 kitchen.js
 Copyright (C) 2015 toshi0383 All Rights Reserved.
*/

var parser;

function defaultPresenter(xml) {
    if(this.loadingIndicatorVisible) {
        navigationDocument.replaceDocument(xml, this.loadingIndicator);
        this.loadingIndicatorVisible = false;
    } else {
        navigationDocument.pushDocument(xml);
    }
}

function searchPresenter(xml) {

    this.defaultPresenter.call(this, xml);
    var doc = xml;

    var searchField = doc.getElementsByTagName("searchField").item(0);
    var keyboard = searchField.getFeature("Keyboard");

    keyboard.onTextChange = function() {
        var searchText = keyboard.text;
        buildResults(doc, searchText);
    }
}

/// Documents presented in the modal view are presented in fullscreen
/// with a semi-transparent background that blurs the document below it.
function modalDialogPresenter(xml) {
    navigationDocument.presentModal(xml);
}

function play(event) {
    var ele = event.target,
        actionID = ele.getAttribute('playActionID');
    if(actionID && typeof playActionIDHandler !== 'undefined'){
        playActionIDHandler(actionID);
        return;
    }
}

function holdselect(event) {
}

function highlight(event) {
}

function load(event) {
    var self = this,
        ele = event.target,
        templateURL = ele.getAttribute("template"),
        presentation = ele.getAttribute("presentation");
        actionID = ele.getAttribute("actionID");
        tagName = ele.tagName;

    if(actionID && typeof actionIDHandler !== 'undefined'){
        actionIDHandler(actionID);
        return;
    }

    if (!templateURL) {
        return;
    }
    self.showLoadingIndicator(presentation);
    loadTemplateFromURL(templateURL, function(resource) {
        present(resource, presentation, ele);
    });
}

function present(resource, presentation, ele) {
    if (!resource) {
        return;
    }
    var self = this;
    var doc = makeDocument(resource);
    doc.addEventListener("select", self.load.bind(self));
    doc.addEventListener("highlight", self.highlight.bind(self));
    doc.addEventListener("holdselect", self.holdselect.bind(self));
    doc.addEventListener("play", self.play.bind(self));


    if (self[presentation] instanceof Function) {
        self[presentation].call(self, doc, ele);
    } else {
        self.defaultPresenter.call(self, doc);
    }
}

function makeDocument(resource) {
    var doc = parser.parseFromString(resource, "application/xml");
    return doc;
}

function showLoadingIndicator(presentation) {
    if (!this.loadingIndicator) {
        this.loadingIndicator = this.makeDocument(loadingTemplate());
    }

    if (!this.loadingIndicatorVisible &&
        presentation != "modalDialogPresenter" &&
        presentation != "menuBarItemPresenter")
    {
        navigationDocument.pushDocument(this.loadingIndicator);
        this.loadingIndicatorVisible = true;
    }
}

/**
 Show the loading indicator for the presentation type passed from UIKit
 */
function showLoadingIndicatorForType(presentationType) {
    if (presentationType == 1 || this.loadingIndicatorVisible) {
        return;
    }

    if (!this.loadingIndicator) {
        this.loadingIndicator = this.makeDocument(loadingTemplate());
    }

    navigationDocument.pushDocument(this.loadingIndicator);
    this.loadingIndicatorVisible = true;
}

function removeLoadingIndicator() {
    if (this.loadingIndicatorVisible) {
        navigationDocument.removeDocument(this.loadingIndicator);
        this.loadingIndicatorVisible = false;
    }
}

function loadingTemplate() {
    return `<?xml version="1.0" encoding="UTF-8" ?>
        <document>
          <loadingTemplate>
            <activityIndicator>
              <text>Loading...</text>
            </activityIndicator>
          </loadingTemplate>
        </document>`
}

/// load template from absolute URL
function loadTemplateFromURL(templateURL, callback, presentationType) {
    var self = this;

    evaluateScripts([templateURL], function(success) {
        if (success) {
            var resource = Template.call(self);
            callback.call(self, resource, presentationType);
        } else {
            var message = `There was an error attempting to load the resource '${resource}' with URL: '${templateURL}'. \n\n Please try again later.`

            removeLoadingIndicator();
            if (kitchenErrorHandler !== undefined) {
                kitchenErrorHandler(message);
            }
        }
    });
}

function presenterForType(type) {
    switch(type) {
        case 1:
            return modalDialogPresenter;
        default:
            return defaultPresenter;
    }
}

/// load template from Main Bundle URL
function openTemplateFromJSFile(jsFileName, presentationType) {
    mainBundleUrl = App.options.MAIN_BUNDLE_URL
    loadTemplateFromURL(`${mainBundleUrl}${jsFileName}`, openTemplateFromXMLString, presentationType);
}

function openTemplateFromURL(url, presentationType) {
    loadTemplateFromURL(`${url}`, openTemplateFromXMLString, presentationType);
}

function openTemplateFromXMLString(xmlString, presentationType) {
    showLoadingIndicatorForType(presentationType);
    var doc = makeDocument(xmlString);
    doc.addEventListener("select", load.bind(this));
    doc.addEventListener("highlight", highlight.bind(this));
    doc.addEventListener("holdselect", holdselect.bind(this));
    doc.addEventListener("play", play.bind(this));

    presenterForType(presentationType).call(this, doc);
}

App.onLaunch = function(options) {
    App.options = options
    parser = new DOMParser();
}
