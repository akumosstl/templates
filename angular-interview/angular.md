# Angular


# What is the difference between Standalone Components and NgModules? When would you use each?

Standalone Components<br>

Introduced in Angular 14+, standalone components:<br>

Do not require an NgModule.<br>

Declare their own dependencies via imports.<br>

Simplify architecture.<br>

Reduce boilerplate.<br>

Example:
```ts
@Component({
  selector: 'app-user',
  standalone: true,
  imports: [CommonModule],
  template: `<p>User works!</p>`
})
export class UserComponent {}
```
NgModules<br>

Traditional Angular structure:<br>

Groups components, pipes, directives.<br>

Manages dependency scope.<br>

Defines feature modules (e.g., UserModule).<br>

When to Use Each?<br>

| Scenario                               | Recommendation                       |
| -------------------------------------- | ------------------------------------ |
| New projects                           | Standalone (default modern approach) |
| Legacy Angular apps                    | NgModules                            |
| Large domain-driven feature separation | Feature modules                      |
| Microfrontends                         | Standalone components                |



Senior Insight<br>

Standalone components improve tree-shaking and reduce cognitive overhead. However, in very large enterprise applications with clear bounded contexts, feature modules still help enforce architectural boundaries.<br>

# How does Parent–Child communication work using @Input and @Output?


Angular supports unidirectional data flow:<br>

@Input → Parent sends data to child.<br>

@Output + EventEmitter → Child emits events to parent.<br>

Concrete Example<br>

Parent Component<br>
```ts
<app-child 
  [user]="selectedUser"
  (userUpdated)="handleUpdate($event)">
</app-child>

handleUpdate(user: User) {
  console.log('Updated user:', user);
}

Child Component
@Input() user!: User;
@Output() userUpdated = new EventEmitter<User>();

updateUser() {
  this.userUpdated.emit(this.user);
}
```
Senior-Level Observation<br>

This pattern enforces unidirectional data flow. Overusing @Output for complex communication may signal poor component architecture — shared services with RxJS streams may be more appropriate.<br>

# Explain Angular Lifecycle Hooks and provide a real-world use case.

| Hook            | Purpose                    |
| --------------- | -------------------------- |
| ngOnInit        | Component initialization   |
| ngOnDestroy     | Cleanup logic              |
| ngOnChanges     | React to input changes     |
| ngAfterViewInit | DOM access after rendering |


Practical Scenario<br>

Problem: Memory leak due to open subscriptions.<br>

Solution using ngOnDestroy:<br>
```ts
private destroy$ = new Subject<void>();

ngOnInit() {
  this.service.getData()
    .pipe(takeUntil(this.destroy$))
    .subscribe();
}

ngOnDestroy() {
  this.destroy$.next();
  this.destroy$.complete();
}
```
Strong Interview Signal<br>

If the candidate mentions:<br>

Preventing memory leaks<br>

DOM manipulation timing<br>

Change detection issues<br>

It shows real-world experience.<br>

# How do you implement routing with Guards? Provide a production scenario.


Angular Router allows route protection using guards such as:<br>

CanActivate<br>

CanDeactivate<br>

CanLoad<br>

Example AuthGuard
```ts
@Injectable({ providedIn: 'root' })
export class AuthGuard implements CanActivate {

  constructor(private authService: AuthService, private router: Router) {}

  canActivate(): boolean {
    if (this.authService.isAuthenticated()) {
      return true;
    }
    this.router.navigate(['/login']);
    return false;
  }
}

Route Configuration
{
  path: 'dashboard',
  component: DashboardComponent,
  canActivate: [AuthGuard]
}
```
Production Scenario<br>

In a banking application:<br>

Protect /dashboard<br>

Validate JWT<br>

Refresh token if expired<br>

Redirect to login if invalid<br>

Senior candidates may mention:<br>

Role-based guards<br>

Lazy loading + CanLoad<br>

Guard returning Observable<boolean><br>

# Why use Observables instead of Promises?


Angular heavily uses RxJS.

| Feature         | Promise | Observable                  |
| --------------- | ------- | --------------------------- |
| Multiple values | ❌       | ✅                           |
| Cancellation    | ❌       | ✅                           |
| Lazy execution  | ❌       | ✅                           |
| Operators       | Limited | Rich (map, switchMap, etc.) |


***When Obserables Are superior***<br>

HTTP streams<br>

WebSocket<br>

Reactive forms<br>

Real-time data<br>

Promises are single-value and eager. Observables are lazy and cancelable.<br>

# Explain pipe and takeUntil.
pipe()<br>

Used to chain operators:<br>
```ts
this.http.get('/api')
  .pipe(
    map(data => transform(data)),
    catchError(err => of([]))
  )
  .subscribe();
```
takeUntil()<br>

Prevents memory leaks:<br>
```ts
.pipe(takeUntil(this.destroy$))
```

Automatically unsubscribes when notifier emits.<br>

# Example of chained (nested) calls — and how to avoid callback hell

❌ Bad Practice (Nested Subscribe)<br>
```ts
this.service.getUser().subscribe(user => {
  this.service.getOrders(user.id).subscribe(orders => {
    console.log(orders);
  });
});
```
✅ Proper RxJS Approach<br>
```ts
this.service.getUser()
  .pipe(
    switchMap(user => this.service.getOrders(user.id))
  )
  .subscribe(orders => console.log(orders));
```
Senior Signal<br>

If the candidate mentions:<br>

switchMap vs mergeMap vs concatMap<br>

Cancellation behavior<br>

Avoiding race conditions<br>

It shows strong RxJS knowledge.<br>

🧠 State Management: Redux / NgRx<br>

# Have you worked with Redux or NgRx? What is Redux?


Redux is a predictable state container based on:<br>

Single source of truth<br>

Immutable state<br>

Pure reducers<br>

Actions describing state changes<br>

In Angular, the equivalent is:<br>

NgRx<br>

# What problem does NgRx solve?


NgRx is useful when:<br>

Complex shared state<br>

Multiple components depend on the same data<br>

Need predictable state transitions<br>

Time-travel debugging<br>

Enterprise-scale applications<br>

Core concepts: <br>

| Concept  | Purpose                      |
| -------- | ---------------------------- |
| Store    | Global state container       |
| Action   | Event describing change      |
| Reducer  | Pure function updating state |
| Effect   | Side effects (API calls)     |
| Selector | Extract data from store      |

Example Flow<br>

Component dispatches Action<br>

Reducer updates Store<br>

Effect calls API<br>

Selector reads updated state<br>

Critical Perspective<br>

Not every application needs NgRx.<br>

Overusing Redux pattern in small apps introduces:<br>

Boilerplate<br>

Complexity<br>

Learning curve<br>

For small/medium apps:<br>

Services + BehaviorSubject may suffice.<br>

Strong candidates should question when to introduce global state management rather than blindly adopting it.<br>


# Angular lifecycle

An Angular component goes through a predictable lifecycle from its creation to its destruction. Developers can use lifecycle hook methods to execute custom logic at specific stages, such as initializing data, responding to input changes, and cleaning up resources. 
Angular calls these lifecycle hooks in a specific order: 

ngOnChanges(): Triggered before ngOnInit() and when data-bound input properties change, providing a SimpleChanges object.

ngOnInit(): Called once after the first ngOnChanges(), commonly used for initialization logic like fetching data.

ngDoCheck(): Executed after ngOnChanges() on every change detection cycle, allowing for custom change detection.

ngAfterContentInit(): Called once after Angular projects external content into the component, enabling access to ContentChild or ContentChildren.

ngAfterContentChecked(): Follows ngAfterContentInit() and subsequent ngDoCheck(), used to respond after projected content is checked.

ngAfterViewInit(): Called once after the component's views and child views are initialized, suitable for DOM manipulation and accessing ViewChild or ViewChildren.

ngAfterViewChecked(): Occurs after ngAfterViewInit() and subsequent ngAfterContentChecked(), used after the component's views are checked.

ngOnDestroy(): Called just before the component or directive is destroyed, essential for cleanup to prevent memory leaks. 

To utilize these hooks, you implement the corresponding interface and define the method in your component or directive class. You can find more information in the official Angular documentation. 

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


# Nested subscription

Handling nested subscriptions in Angular is best achieved by flattening them using RxJS higher-order mapping operators (switchMap, mergeMap, concatMap) instead of subscribing inside another subscription. These operators avoid memory leaks, improve readability, and ensure proper error handling. 

Key Strategies for Nested Subscriptions:

switchMap (Preferred): Ideal for scenarios where a new inner observable should cancel the previous one (e.g., search-as-you-type).
mergeMap: Use when all inner observables should run concurrently.

concatMap: Use when order of execution matters and should be maintained.

forkJoin: Ideal for running multiple API requests in parallel and waiting for all to complete before proceeding.

Async Pipe (| async): Use this in templates to automatically handle subscription and unsubscription, preventing memory leaks. 

Example: Replacing Nested Subscriptions

Instead of:
```typescript
// Antipattern: Nested Subscription
this.route.params.subscribe(params => {
  this.service.getData(params.id).subscribe(data => {
    this.data = data;
  });
});
```
Use Operator Flattening: 
```typescript
// Best Practice: Flattened with switchMap
this.data$ = this.route.params.pipe(
  map(params => params.id),
  switchMap(id => this.service.getData(id))
);
// Use this.data$ | async in the template
```

Additional Tips:

Avoid Subscribing: Only subscribe when absolutely necessary; prefer operator pipelines and async pipes.

ngOnDestroy: If manual subscription is unavoidable, ensure you unsubscribe to prevent memory leaks, using takeUntil or Subscription.add().
Error Handling: Use catchError within the operator pipe to manage errors from inner streams effectively. 