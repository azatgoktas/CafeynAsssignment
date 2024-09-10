## Cafeyn Interest Selection

* This application fetches and displays Cafeyn topics.
* It is built using Xcode 15.3 and follows the MVVM (Model-View-ViewModel) design pattern for a clean and maintainable codebase.
* A separate Swift Package Manager (SPM) package handles networking, ensuring modularity and reusability.
* The code is highly testable, with unit tests covering all use cases.
* I kept the scope relatively small and aimed the show architechting and iOS skills, further improvements can be done.


## Architecture

<img src="./arch.jpg" width ="500">  

* The data layer is clearly seperated from UI Layer.
* All the dependencies injected and abstracted, which can be easily injected. 
* The view only has the view logics such as laying out the view, animations etc.
* There's a small swiftui view to show it can be used from UIKit as well.

## How to run

Opening Xcode and running the project will be enough, no further action is needed to run the app.
