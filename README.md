# NewsFeed

**News Articles App with MVVM and Coordinator Pattern**

This iOS app consumes the provided API endpoint to display a list of news articles to the user. The app's purpose is to allow users to browse and read news articles from various categories. The main features include:

1. Integration with the API endpoint: The app fetches news articles from the API endpoint located at `https://bruce-v2-mob.fairfaxmedia.com.au/1/coding_test/13ZZQX/full`. The articles are retrieved and displayed via `ArticlesViewController`

2. Use of Cocoapods and Kingfisher library: Cocoapods is used as the dependency management tool, and the [Kingfisher](https://github.com/onevcat/Kingfisher) is integrated to facilitate image loading and caching. The library is known for its efficient image fetching and built-in caching capabilities.

```ruby
# Install Cocoapods
$ sudo gem install cocoapods

# Create a Podfile
$ pod init

# Open the Podfile and add the following line
pod 'Kingfisher'

# Save the Podfile and install dependencies
$ pod install
```

3. Architecture and design patterns: The app is developed using the MVVM (Model-View-ViewModel) architectural pattern with delegates, along with the Coordinator pattern for navigation. This promotes separation of concerns and enhances code maintainability.

4. Notable classes:
   - `AppCoordinator`: Responsible for managing the navigation flow within the app.
   - `NetworkService`: Handles the fetching and decoding of news articles from the API.
   - `CategoriesViewController`: Displays a UICollectionView with unique categories of news articles.
   - `CategoriesViewModel`: Facilitates interaction with the NetworkService and updates the CategoriesViewController.
   - `ArticlesViewController`: Shows a UITableView with article cells, allowing users to present a WKWebView for reading articles.
   - `ArticlesViewModel`: Orders the articles by timestamp and updates the ArticlesViewController.
   - `ErrorPresenter`: Handles the presentation of error messages.

5. Unit tests and UI tests: The PR includes tests covering critical functionalities. Test classes include `NetworkServiceTests`, `CategoriesViewModelTests`, `ArticlesViewModelTest` and `CategoriesViewControllerUITests`. I'd like to add more UI tests, but the time constraint for this code challenge is acknowledged.

6. Layout and styling: The app's layout is implemented programmatically, and the main storyboard has been removed. I prefer SnapKit library typically for creating flexible and readable constraints, although in this case, NSLayoutConstraints were used for simplicity. A separate constants file holds color and font constants for consistency.

7. Extensions and utilities: extensions for Date and UIColor types. These extensions allow for converting a hex value to a UIColor and formatting a Date as a user-friendly "time since now" string.

The app is built using a clean architecture, utilises a popular third-party library for image handling. The use of MVVM and Coordinator patterns ensures separation of concerns and improves code organization.


*Note this app does not support dark-mode or horizontal orientation*
