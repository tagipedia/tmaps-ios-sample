# tmaps-ios-sample

## Installation
### To integrate TMaps into your Xcode project, add it to your project:
1- Create folder named tmapswww
2- Download and Unzip map package inside tmapswww (Request map package from Tagipedia Team)
3- See our sample

## Usage
### dispatches

#### dispatch load map

```objc
@{
   @"type": @"LOAD_MAP",
   @"map_id": map_id,
   @"theme": @{
      @"primary": primary_color,
      @"accent": accent_color
   },
   @"center": @[lng, lat],
   @"zoom": zoom
};
```

map_id
Required NSString

theme
Optional NSDictionary of keys primary, accent
primary, accent values must be valid NSString color

center
Optional NSArray of NSNumbers
Default map center in longitude and latitude.

zoom
Optional NSNumber






