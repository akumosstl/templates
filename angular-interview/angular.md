# ChangeDetectionStrategy.OnPush

ChangeDetectionStrategy.OnPush is an Angular performance optimization technique that tells the framework to run change detection for a component and its subtree only when specific conditions are met, rather than on every single application-wide change. 
How to use OnPush
To use the OnPush strategy, you specify it in the component's metadata: 

```ts
import { Component, ChangeDetectionStrategy } from '@angular/core';

@Component({
  selector: 'app-my-component',
  templateUrl: './my-component.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush, // Set the strategy to OnPush
  styleUrls: ['./my-component.component.scss']
})
export class MyComponent {
  // ... component logic
}
```

You can also set OnPush as the default for all newly generated components in your angular.json file. 
When does OnPush trigger change detection?
With ChangeDetectionStrategy.OnPush, Angular only checks for changes in a component's view if one of the following occurs: 
A new @Input() reference is received The input object itself must change (immutable change), not just a property within the object.
An event is fired from the component or its children (e.g., a (click) event, form binding, or @HostListener triggers an event handler within the component's subtree).
An async pipe emits a new value in the component's template, as the pipe automatically marks the component as "dirty" or in need of a check.
Change detection is manually invoked using methods like markForCheck() or detectChanges() from the ChangeDetectorRef service.
A Signal value is read in the component's template or a computed property that is read in the template changes (this is the modern, highly performant approach). 
Benefits
Improved Performance: By skipping entire component subtrees when their inputs haven't changed, Angular performs significantly fewer checks, leading to faster re-rendering and a more efficient application, especially in complex UIs.
Predictable Behavior: It encourages the use of immutable data structures and a unidirectional data flow, making the application's state changes easier to track and debug. 
OnPush is widely considered a best practice in modern Angular development and is expected to become the default change detection strategy in a future version of Angular. 

# The ChangeDetectorRef

The ChangeDetectorRef in Angular is a service that allows developers to gain explicit, manual control over the framework's change detection mechanism for a specific component and its view hierarchy. It is primarily used in scenarios requiring performance optimizations, such as when using the OnPush change detection strategy, or when changes occur outside of the Angular zone. 
Key Methods of ChangeDetectorRef
You can inject the ChangeDetectorRef service into your component using dependency injection: 
typescript
import { ChangeDetectorRef, Component } from '@angular/core';

```ts
@Component({
  // ... component metadata
})
export class MyComponent {
  constructor(private cdr: ChangeDetectorRef) {}
}
```
The service provides several methods to manage change detection: 
markForCheck(): This does not trigger an immediate change detection run, but rather marks the component (and its ancestors up to the root) as "dirty" (in need of a check) for the next standard change detection cycle. This is essential when using OnPush strategy and data has changed in a way Angular won't automatically detect (e.g., an object's internal property was mutated instead of the reference being updated, or a change occurred from a third-party library's callback).
detectChanges(): This forces an immediate, one-time change detection check for the current component and its children, regardless of their change detection strategy (even if OnPush is used or the component is detached). It is useful in combination with detach() to implement highly localized and controlled updates.
detach(): This removes the component's change detector from the change detection tree. The component and its sub-tree will not be checked during the normal change detection runs until reattached. This offers maximum control and performance benefits for components with read-only, static data, or when you want to update the view at specific, infrequent intervals.
reattach(): This re-attaches a previously detached change detector to the tree, allowing it to be included in future change detection cycles.
checkNoChanges(): Available in development mode, this method checks the view and its children and throws an error if any changes are detected. This helps verify that a change detection run is stable and doesn't cause further changes (preventing infinite loops). 
Common Use Cases
OnPush Strategy: The most common use case is with ChangeDetectionStrategy.OnPush. When an input property is mutated but its reference remains the same (e.g., pushing an item into an existing array), Angular with OnPush won't detect the change. Using markForCheck() or detectChanges() solves this.
External Libraries/APIs: When working with third-party JavaScript libraries that perform actions outside of the Angular zone (like certain WebSocket callbacks or D3.js updates), Angular needs to be manually notified of changes. ChangeDetectorRef is the tool for this.
Performance Optimization: For large lists or complex components where data changes frequently but the view doesn't need to update in real-time, detach() can be used to manually control when the component is updated, perhaps only every few seconds using detectChanges(). 
While powerful, overusing ChangeDetectorRef can sometimes signal underlying architectural issues; it is often better to ensure proper data flow, use immutable data, or leverage the async pipe when possible. 