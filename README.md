# Radio app

## What the app offers

It's a simple app that allows the user to listen and favorite radio stations listed through the [Community Radio Station](https://at1.api.radio-browser.info/) free API service.

As the app is super simple, so is its architecture. It tries to follow the clean arquitecture principles splitting into:

- **Model layer** - our entities, which consist only on radio stations 🤷‍♂️
- **Business logic layer** - where we have the Cubit's and Repositories
- **Presentation layer** - all the Flutter framework specific stuff

## How to execute

You will need Flutter version >= 3.7.11

If you use VSCode there's an automatic Run option configured.

Otherwise you can just run `flutter run` from the root folder.

## Relevant dependencies

- `just_audio` - audio player library
- `flutter_bloc` - state management solution
- `get_it` - service locator pattern implementation
- `equatable` - combined with the BLoC pattern to optimise state rendering
- `flutter_easyloading` - provides some nice loaders by default
- `lottie` - cool animations format, used only in the animation on the splash
- `animated_text_kit` - to give a nice and shinny effect on a text of the player screen
- `rxdart` - to reactively expose the data stored so the BLoCs reacts accordingly.
- `json_annotation` - automatic serialisation/deserialisation code generator (and avoid some manual code work)
