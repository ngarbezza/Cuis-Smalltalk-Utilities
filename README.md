# Cuis-Smalltalk-Utilities

A random set of Cuis Smalltalk packages from my own. Feel free to include it on your projects if you find them useful :-)

**Installation**: all of the files are bundled as packages, just drop the file into your Cuis image and then choose "Install package".

## Flaky Tests Detector

This is a very simple tool that allows you to check if a test has a flaky behavior, that is, failing from time to time.

It's very simple to use this tool. Just right-click on a test method, and select the "Analyze test flakiness" and it'll run your test 100 times (can be changed if called programmatically) and it will display the percentage of failures, and a list of each execution.

Here's a quick demo of this feature:

![Flaky Tests Demo](/demos/flaky-tests-demo.gif)

## Percentage object

A simple class that represents percentages, plus a convenience method on Number that allows you to write things like: `50 percent of: 2000`.

## Collaborations counter

Small tool to count the number of collaborations (message sends) in a method. It displays the results in the Browser's annotation pane.

To enable it, evaluate `Preferences enableAnnotationInfo: #collaborationsCount`.
To disable it, evaluate `Preferences disableAnnotationInfo: #collaborationsCount`.

Here's a quick demo of this tool:

![Collaborations Counter Demo](/demos/collaborations-counter-demo.gif)

## Examples Browser

A tool that allows you to define examples for any method in the image, and browse them using a button in any Cuis' code browser.

Demo:

![Examples Browser Demo](/demos/cuis-examples-browser.gif)