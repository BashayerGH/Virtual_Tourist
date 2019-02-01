# Virtual Tourist
The Virtual Tourist app downloads and stores images from Flickr. The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.


# Requirements
* Xcode 10.1
* Swift 4.2

# How it works
When the app first starts, it will open to the map view. the user will be able to zoom and scroll around the map using standard pinch and drag gestures.


Tapping and holding the map drops a new pin. The user can place any number of pins on the map. When a pin is tapped, the app will navigate to the Photo Album view associated with the pin.
If the app is turned off, the map will return to the same state when it is turned on again.

If the user taps a pin that does not yet have a photo album, the app will download Flickr images associated with the latitude and longitude of the pin. If no images are found a “No Images” label will be displayed. If there are images, then they will be displayed in a collection view. While the images are downloading, the photo album is in a temporary “downloading” state in which the New Collection button is disabled. The app will determine how many images are available for the pin location, and display a placeholder image for each.

Once the images have all be downloaded, the app will enable  "New Collection" button at the bottom of the page. Tapping this button will empty the photo album and fetch a new set of images.

If the user selects a pin that already has a photo album then the Photo Album view will display the album and "New Collection" button will be enabled.
