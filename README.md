RAC
===

Reactive Cocoa, or RAC, is a cool new framework that brings functional reactive
programming to Objective-C. Reactive Cocoa allows you to think about your
application from the standpoint of data flow as opposed to manipulations of
mutable variables. RAC introduces the notion of a signal. A signal represents a
value or values that continually change over time. When programming with RAC we
chain together, combine, and manipulate these signals to write code in a
declarative fashion, specifying what to compute instead of how it should be
computed. RAC signals can be used to greatly simplify asynchronous tasks,
offering a unified paradigm in place of such asynchronous patterns as delegate
methods, callback blocks, target-action mechanisms, notifications, and KVO.
This presentation will introduce you to programming with Reactive Cocoa. We’ll
go over the basic concepts of functional reactive programming, some of the cool
things you can do with RAC, and how RAC can help you write code that is more
readable, modular, and testable.
