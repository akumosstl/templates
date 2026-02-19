# Angular Interview Questions and Answers

# What is Angular?

Angular is a TypeScript-based front-end framework developed by Google
for building single-page applications (SPAs) using a component-based
architecture.

------------------------------------------------------------------------

# What is the difference between Components and Modules?

-   Components control a portion of the UI (view + logic).
-   Modules group related components, directives, pipes, and services
    into cohesive blocks of functionality.

------------------------------------------------------------------------

# What are Standalone Components?

Standalone components (Angular 14+) do not require an NgModule. They can
directly declare their own dependencies and simplify application
structure.

------------------------------------------------------------------------

# What is Data Binding in Angular?

Data binding is the mechanism to synchronize data between the component
and the template. Types: - Interpolation {{ }} - Property binding \[
\] - Event binding ( ) - Two-way binding \[(ngModel)\]

------------------------------------------------------------------------

# What is Dependency Injection in Angular?

Angular has a hierarchical dependency injection system that provides
services to components via constructors.

Example: constructor(private userService: UserService) {}

------------------------------------------------------------------------

# What are Lifecycle Hooks in Angular?

Lifecycle hooks allow you to tap into key moments in a component's
lifecycle. Common hooks: - ngOnInit - ngOnChanges - ngOnDestroy -
ngAfterViewInit

------------------------------------------------------------------------

# What is RxJS and why is it used in Angular?

RxJS is a reactive programming library used for handling asynchronous
operations using Observables. Angular heavily uses Observables in
HttpClient and event handling.

------------------------------------------------------------------------

# What is the difference between Promise and Observable?

-   Promise emits a single value.
-   Observable can emit multiple values over time.
-   Observable supports operators (map, filter, switchMap).
-   Observable can be cancelled (unsubscribe).

------------------------------------------------------------------------

# What is Change Detection in Angular?

Change detection is the mechanism Angular uses to update the DOM when
data changes. It runs automatically and can be optimized using
ChangeDetectionStrategy.OnPush.

------------------------------------------------------------------------

# What is Lazy Loading in Angular?

Lazy loading loads feature modules only when required via route
configuration, improving performance and reducing initial bundle size.

Example: { path: 'admin', loadChildren: () =\>
import('./admin/admin.module').then(m =\> m.AdminModule) }
