# TaskSphere — Advanced State Management with Provider

TaskSphere is a mission-focused task management application built with Flutter. This project marks the complete architectural refactoring of the application's state management layer—migrating away from tightly coupled local `setState` changes to a clean, scalable reactive architecture utilizing the **Provider** ecosystem. 

The application uses an immersive, cyber-space user interface to handle real-time CRUD operations on dynamic tracking modules ("Missions").

## 📱 Visual Walkthrough & System States

### Welcome Terminal
 <img width="1038" height="604" alt="T6 1" src="https://github.com/user-attachments/assets/00e18845-f77e-447b-9698-c46b30404d06" />

### Empty Sphere Status
 <img width="1028" height="608" alt="T6 2" src="https://github.com/user-attachments/assets/db77a517-f8db-4fa9-ab7f-e29bfaaab16d" />

### Deploy Mission Modal
 <img width="751" height="317" alt="T6 3" src="https://github.com/user-attachments/assets/d75997a6-626a-4bf5-a459-d188c67d32a1" />

### Synced Node View  
<img width="1028" height="617" alt="T6 4" src="https://github.com/user-attachments/assets/500b6ee7-44aa-4583-b5da-89763da4a473" />

### Structural Updating
<img width="723" height="276" alt="t6 5" src="https://github.com/user-attachments/assets/9f08fcc5-8c26-4ec1-ab07-c4cba41c61c2" />

### Real-Time Performance
<img width="1034" height="614" alt="t6 6" src="https://github.com/user-attachments/assets/ec446705-3702-425b-9899-eb37e9be4776" />

---

## 🚀 Key Features Implemented

### 1. Architectural Refactoring via Provider
* **Decoupled Business Logic:** Extracted state logic out of view classes and consolidated it inside a clean `TaskProvider` layer extending `ChangeNotifier`.
* **Reactive Layout Updates:** Used scoped `Consumer` widgets to target rebuilds exclusively to components that change, maximizing application performance and eliminating resource leaks.

### 2. Complete State CRUD Pipeline
* **Deploy Mission (Create):** Captures custom parameters (`Mission Title`, `Description`) with responsive validation layouts.
* **Read / Dynamic Metric Tracking:** Dynamically tracks total active units and completed counts using an active circular progress indicator.
* **Update / Edit Interface:** Retains historical text values upon selecting a node element, updating structural specifications on submission.
* **Delete / Clear Node:** Instant document purging with smooth list updates.

### 3. Micro-Animations & Optimization
* Implements crisp structural state switches when transitioning from an empty space view ("No Tasks Yet") to active lists.
* Leverages optimized constructor caching (`const` modifiers) to ensure non-reactive UI nodes bypass rebuild loops.

---

