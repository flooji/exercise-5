// personal assistant agent 

/* Task 2 Start of your solution */
/* Initial beliefs */

// The agent believes that the preferred wakeup method is...
artificial_light(2).
natural_light(1).
vibrations(0).

/* Initial rules */
// Inference rule for infering the belief best_option depending on which wakeup method is the prefered one
is_best_option_vibrations:- vibrations(V) & artificial_light(A) & natural_light(N) & (V < A) & (V < N).
is_best_option_natural_light:- vibrations(V) & artificial_light(A) & natural_light(N) & (N < V) & (N < A).
is_best_option_artificial_light:- vibrations(V) & artificial_light(A) & natural_light(N) & (A < V) & (A < N).

no_options_left:- vibrations(V) & artificial_light(A) & natural_light(N) & V == A & V == N.

/* Initial goals */

// The agent has the initial goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: true (the plan is always applicable)
 * Body: every 2000ms, the agent strives to maintain the illuminance in the room at the target level 
*/
@start_plan
+!start : true <-
    .print("Assist user in daily activities");
    .wait(2000);
    !assist_user;
    !start.

/* 
 * Plan for reacting to the addition of the goal !assist_user
 * Triggering event: addition of goal !assist_user
 * Context: the agent believes that the upcoming_event is "now" & the owner is "asleep" and the best option is "vibrations"
 * Body: the agent starts the wake up routine
*/
@wakeup_user_plan_with_vibrations
+!assist_user: upcoming_event("now") & owner_state("asleep") & is_best_option_vibrations <-
    setVibrationsMode;
    -+vibrations(3); // remove and add the new belief, we put it to a value higher than 0, 1 or 2
    .print("Wake up user with mattress vibrations").


/* 
 * Plan for reacting to the addition of the goal !assist_user
 * Triggering event: addition of goal !assist_user
 * Context: the agent believes that the upcoming_event is "now" & the owner is "asleep" and the best option is "natural_light"
 * Body: the agent starts the wake up routine
*/
@wakeup_user_plan_with_natural_light
+!assist_user: upcoming_event("now") & owner_state("asleep") & is_best_option_natural_light <-
    raiseBlinds;
    -+natural_light(3);
    .print("Wake up user with natural light").


/* 
 * Plan for reacting to the addition of the goal !assist_user
 * Triggering event: addition of goal !assist_user
 * Context: the agent believes that the upcoming_event is "now" & the owner is "asleep" and the best option is "artifical_light"
 * Body: the agent starts the wake up routine
*/
@wakeup_user_plan_with_artificial_light
+!assist_user: upcoming_event("now") & owner_state("asleep") & is_best_option_artificial_light <-
    turnOnLights;
    -+artificial_light(3);
    .print("Wake up user with artificial light").


/* 
 * Plan for reacting to the addition of the goal !assist_user
 * Triggering event: addition of goal !assist_suer
 * Context: the agent believes that the upcoming_event is "now" & the owner is "asleep" and there is no best option
 * Body: the agent starts the wake up routine
*/
@wakeup_user_plan_no_more_options
+!assist_user: upcoming_event("now") & owner_state("asleep") & no_options_left <-
    .print("Tried everything - no unused wakeup methods left.").


/* 
 * Plan for reacting to the addition of the goal !assist_user
 * Triggering event: addition of goal !assist_user
 * Context: the agent believes that the upcoming_event is "now" and that the owner is "awake"
 * Body: the agent greets the owner
*/
@greet_user_plan
+!assist_user : upcoming_event("now") & owner_state("awake") <-
    .print("Enjoy your event").


/* 
 * Plan for reacting to the addition of the belief owner_state(State)
 * Triggering event: addition of belief owner_state(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the owner
*/
@owner_state_plan   
+owner_state(State) : true <- 
    .print("The user is ", State).

/* 
 * Plan for reacting to the addition of the belief upcoming_event(State)
 * Triggering event: addition of belief upcoming_event(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the upcoming_event
*/
@upcoming_event_plan
+upcoming_event(State) : true <- 
    .print("New upcoming event ", State).

/* 
 * Plan for reacting to the addition of the belief mattress(State)
 * Triggering event: addition of belief mattress(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the mattress
*/
@mattress_plan
+mattress(State) : true <- 
    .print("The mattress is in mode ", State).

/* 
 * Plan for reacting to the addition of the belief blinds(State)
 * Triggering event: addition of belief blinds(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the blinds
*/
@best_option_plan
+best_option(State) : true <- 
    .print("The best wakeup method is ", State).

/* 
 * Plan for reacting to the addition of the belief blinds(State)
 * Triggering event: addition of belief blinds(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the blinds
*/
@blinds_plan
+blinds(State) : true <- 
    .print("The blinds are ", State).

/* 
 * Plan for reacting to the addition of the belief lights(State)
 * Triggering event: addition of belief lights(State)
 * Context: true (the plan is always applicable)
 * Body: prints the state of the lights
*/
@lights_plan
+lights(State) : true <- 
    .print("The lights are ", State).
/* Task 2 End of your solution */

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }