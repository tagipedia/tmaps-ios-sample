# tmaps-ios-sample

## Installation
### To integrate TMaps into your Xcode project, add it to your project:
1- Create folder named tmapswww
2- Download and Unzip map package inside tmapswww (Request map package from Tagipedia Team)
3- Read our sample for examples

## Usage
### TMaps dispatches to Your APP

```objc
@{
   @"type": @"READY"
};
```

```objc
@{
   @"type": @"MAP_LOADED"
};
```

```objc
@{
   @"type": @"FEATURES_TAPPED",
   @"features": features
};
```

features
Required NSArray with NSDictionary, each NSDictionary with id, properties keys

```objc
@{
   @"type": @"ASSOCIATED_FEATURE_TAPPED",
   @"feature_id": feature_id,
   @"feature": feature
};
```

feature_id
Required NSString with valid feature id

feature
Required NSDictionary with id, properties keys

```objc
@{
   @"type": @"FEATURE_MARKED"
};
```

feature_id
Required NSString with valid feature id

```objc
@{
   @"type": @"FEATURE_HIGHLIGHTED"
};
```

feature_id
Required NSString with valid feature id

```objc
@{
   @"type": @"ZOOM_ENDED"
};
```

dispatched after SET_ZOOM you called end

```objc
@{
   @"type": @"CENTER_ENDED"
};
```

dispatched after SET_CENTER you called end

```objc
@{
   @"type": @"CATEGORY_MARKED",
   @"category": category
};
```

category
Required valid NSString category


```objc
@{
   @"type": @"ERROR",
   @"error": error
};
```

error
Required NSDictionary with stack key and NSString value

### Your APP dispatches to TMaps

#### Set tenant data 

```objc
@{
   @"type": @"SET_TENANT_DATA",
   @"payload": tenants_json
};
```

payload
Required NSArray with NSDictionary, each NSDictionary with id, feature_id, name, booth_id, icon, CUSTOM_KEYS_YOU_NEED keys

#### Set default feature popup template

```objc
@{
   @"type": @"SET_DEFAULT_FEATURE_POPUP_TEMPLATE",
   @"template": template,
   @"template_custom_data": templateCustomData,
};
```

template
Required valid NSString angular

template_custom_data
Optional NSDictionary with CUSTOM_KEYS_YOU_NEED keys and NSString, NSNumber, NSArray, NSDictionary values

#### Set theme

```objc
@{
   @"primary": primary_color,
   @"accent": accent_color
};
```

primary
Optional valid NSString color

accent
Optional valid NSString color


#### Load map

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
id of packaged map 

theme
Optional NSDictionary with primary, accent keys and valid NSString color values
theme used for colors such as buttons and loading

center
Optional NSArray of NSNumbers
Default map center in longitude and latitude

zoom
Optional NSNumber
Default zoom level

#### Change render mode

```objc
@{
   @"type": @"CHANGE_RENDER_MODE",
   @"modeToRender": modeToRender
}
```

modeToRender
Required NSString with 2D, 3D


#### Set zoom

```objc
@{
   @"type": @"SET_ZOOM",
   @"zoom": zoom,
   @"zoom_type": zoom_type,
}
```

zoom
Required NSNumber

zoom_type
Optional NSString with FLY_TO

#### Set center

```objc
@{
   @"type": @"SET_CENTER",
   @"center": @[lng, lat],
}
```

center
Required NSArray of NSNumbers
Default map center in longitude and latitude


#### Highlight feature

```objc
@{
   @"type": @"HIGHLIGHT_FEATURE",
   @"feature_id": feature_id
}
```

feature_id
Required NSString with valid feature id

#### Mark feature

```objc
@{
   @"type": @"MARK_FEATURE",
   @"feature_id": feature_id
}
```

feature_id
Required NSString with valid feature id














