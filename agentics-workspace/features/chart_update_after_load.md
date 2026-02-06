This document is a description and helper to implement the 'chart_update_after_load' FEATURE

[TERMS]
 - 'ChartComponent' = src\app\components\chart\chart.component.ts
 - 'TableComponent' = src\app\components\table\table.component.ts
 - 'AppComponent' = src\app\app.component.ts
 - 'Maneuver' = src\app\models\maneuver.model.ts
 

[STRICT_RULES]

 - Currently the application has features and behaviors that could not be altered
 - The current application status in terms of features is well stable, so be carefuly to not refactory what already is working
 - You MUST read the thecnical components project and flows description before init your job/mission/task. The documentation is at : ````#file:C:\Users\MEUCOMPUTADOR\.agentic-workspace\portosantos\agentics\wiki\portosantos.md```

 [ALREADY_IMPLEMENTED_FEATURES_FLOW_DESCRIPTION]

 To complete the description bellow You MUST had read: ````#file:C:\Users\MEUCOMPUTADOR\.agentic-workspace\portosantos\agentics\wiki\portosantos.md```


- The 'AppComponent' has two buttons with these labels: 'carregar' and 'otimizar'
- When 'carregar' is clicked one backend endpoint returns a list of 'Maneuver'
- currently the function bellow is doing the sync, but there is a problem: 
```ts
 onManeuversChange(updatedManeuvers: ManeuverItem[]) {
    this.maneuversRaw = updatedManeuvers;
    // Emit update to both chart and table by reassigning maneuversRaw (Angular will propagate to both)
    this.cdr.detectChanges();
  }

```
- The problem is the chart is emitting the event without the new position chart line, that means the user move the chart line, it has a new preferredStartTime value, but it isnt update the table.

- Pay attention it is happening just after click at 'otimizar' buton. 
- Try to learn with the same feature implemented at 'carregar'
- But remember when 'otimizar' is clicked to build the chart is used the scheduledStartTime  instead of preferredStartTime, and when move the chart line the table should be updated usisng preferredStartTime
- And this list should update the rows either in table and chart, but just chart is updating
- you must fix it.