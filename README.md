# tmaps-ios-sample

## Installation
### To integrate TMaps into your Xcode project, add it to your project:
1. Create folder named tmapswww
2. Download and Unzip map package inside tmapswww (Request map package from Tagipedia Team)
3. Read our sample for examples

## How it works
it works using dispatch actions between your APP and TMaps. So your APP dispatch actions to TMaps and TMaps dispatch actions to your APP.

## Usage
### TMaps actions dispatched to Your APP

#### Ready

dispatched when TMaps ready to receive dispatches from Your APP. So you should not dispatch any action before TMaps get ready.

```objc
@{
   @"type": @"READY"
};
```

___

#### Map loaded

dispatched when map loaded and visible to user.

```objc
@{
   @"type": @"MAP_LOADED"
};
```
___

#### Features tapped

dispatched when features in map tapped.

```objc
@{
   @"type": @"FEATURES_TAPPED",
   @"features": features
};
```

&nbsp;&nbsp;&nbsp;&nbsp;**features** <br/>
&nbsp;&nbsp;&nbsp;&nbsp;**Required** *NSArray* with *NSDictionary*, each *NSDictionary* with *id*, *properties* keys

___


#### Associated feature tapped

dispatched when features in map tapped. and choose them most top feature visible to user.

```objc
@{
   @"type": @"ASSOCIATED_FEATURE_TAPPED",
   @"feature_id": feature_id,
   @"feature": feature
};
```

&nbsp;&nbsp;&nbsp;&nbsp;**feature_id** <br/>
&nbsp;&nbsp;&nbsp;&nbsp;**Required** *NSString* with valid feature id

&nbsp;&nbsp;&nbsp;&nbsp;**feature** <br/>
&nbsp;&nbsp;&nbsp;&nbsp;**Required** *NSDictionary* with *id*, *properties* keys

___

#### Feature marked

dispatched after MARK_FEATURE you called end

```objc
@{
   @"type": @"FEATURE_MARKED",
   @"feature_id": feature_id
};
```

&nbsp;&nbsp;&nbsp;&nbsp;**feature_id** <br/>
&nbsp;&nbsp;&nbsp;&nbsp;**Required** *NSString* with valid feature id

___

#### Feature highlighted

dispatched after HIGHLIGHT_FEATURE you called end

```objc
@{
   @"type": @"FEATURE_HIGHLIGHTED",
   @"feature_id": feature_id
};
```

&nbsp;&nbsp;&nbsp;&nbsp;**feature_id** <br/>
&nbsp;&nbsp;&nbsp;&nbsp;**Required** *NSString* with valid feature id

___

#### Zoom ended

dispatched after SET_ZOOM you called end

```objc
@{
   @"type": @"ZOOM_ENDED"
};
```
___

#### Center ended

dispatched after SET_CENTER you called end

```objc
@{
   @"type": @"CENTER_ENDED"
};
```
___

#### Category marked

dispatched after mark category

```objc
@{
   @"type": @"CATEGORY_MARKED",
   @"category": category
};
```

&nbsp;&nbsp;&nbsp;&nbsp;**category** <br/>
&nbsp;&nbsp;&nbsp;&nbsp;**Required** valid *NSString* category

___

#### Error

dispatched when error happened in TMaps

```objc
@{
   @"type": @"ERROR",
   @"error": error
};
```

&nbsp;&nbsp;&nbsp;&nbsp;**error** <br/>
&nbsp;&nbsp;&nbsp;&nbsp;**Required** *NSDictionary* with *stack* key and *NSString* value


### Your APP actions dispatched to TMaps

#### Set tenant data 

dispatched 

```objc
@{
   @"type": @"SET_TENANT_DATA",
   @"payload": tenants_json
};
```

&nbsp;&nbsp;&nbsp;&nbsp;**payload** <br/>
&nbsp;&nbsp;&nbsp;&nbsp;**Required** *NSArray* with *NSDictionary*, each *NSDictionary* with *id*, *feature_id*, *name*, *booth_id*, *icon*, *CUSTOM_KEYS_YOU_NEED* keys

___

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

___

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

___

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

___

#### Change render mode

```objc
@{
   @"type": @"CHANGE_RENDER_MODE",
   @"modeToRender": modeToRender
}
```

modeToRender
Required NSString with 2D, 3D

___


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

___

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

___

#### Highlight feature

```objc
@{
   @"type": @"HIGHLIGHT_FEATURE",
   @"feature_id": feature_id
}
```

feature_id
Required NSString with valid feature id

___

#### Mark feature

```objc
@{
   @"type": @"MARK_FEATURE",
   @"feature_id": feature_id
}
```

feature_id
Required NSString with valid feature id













