# Embergo

Embergo is a simple example example of using [Go](http://golang.org) as a back end for [EmberJS](http://emberjs.org).  The original source for this code is a series of blog posts from [Nerdy Worm](http://nerdyworm.com/blog) starting with the post [Building an app with Ember.js and Go](http://nerdyworm.com/blog/2013/05/21/building-an-app-with-ember-dot-js-and-go/).  The Go server makes use of the [Gorilla Toolkit](http://www.gorillatoolkit.org/) to provide a REST-like server for EmberJS to consume.

# Kittens?

The application allows the user to name kittens and display them on the screen along side their picture, lovingly taken from [Place Kitten](http://placekitten.com).

# What Ember Needs from a back end

To handle our applications, We will need to perform the following actions

* DELETE a kitten
* PUT a kitten
* GET all kittens
* POST a new kitten

```{ go server.go:router_setup }
  r := mux.NewRouter()
  r.HandleFunc("/api/kittens/{id}", DeleteKittenHandler).Methods("DELETE")
  r.HandleFunc("/api/kittens/{id}", UpdateKittenHandler).Methods("PUT")
  r.HandleFunc("/api/kittens", KittensHandler).Methods("GET")
  r.HandleFunc("/api/kittens", CreateKittenHandler).Methods("POST")
  http.Handle("/api/", r)
```

## All the Kittens!

The list of kittens is handled in the following way:

1. set the content type to application/json
2. marshall the kittens list to json
3. die, becaus if we can't convert kittens to json, we're in trouble.
4. write our json kittens to the response

```{ go server.go:kittens_handler }
func KittensHandler(w http.ResponseWriter, r* http.Request){
  w.Header().Set("content-type", "application/json")
  j, err := json.Marshal(KittensJSON{Kittens: kittens})
  if err != nil {
    panic(err)
  }
  w.Write(j)
}
```

## A kitten is Born!

Creating a kitten contains the following steps:

1. starts by decoding the posted kitten.
2. The kitten is then given a unique Id and a picture URL.
3. Then we add the kitten to the litter.
4. We next turn the kitten back in to json, set the response type to json, and write it to the response.

```{ go server.go:create_kitten_handler }
func CreateKittenHandler(w http.ResponseWriter, r *http.Request){
  var kittenJSON KittenJSON
  err := json.NewDecoder(r.Body).Decode(&kittenJSON)
  if err != nil {
    panic(err)
  }

  kitten := kittenJSON.Kitten
  kitten.Id = len(kittens) + 1
  kitten.Picture = "http://placekitten.com/300/200"

  kittens = append(kittens, kitten)

  j, err := json.Marshal(KittenJSON{Kitten: kitten})
  if err != nil {
    panic(err)
  }

  w.Header().Set("Content-Type", "application/json")
  w.Write(j)
}
```

## They grow up so fast...

Updating a kitten requires the following:

1. Convert the id from the url to an integer
2. Decode the updated kitten from json
3. find the kitten in the list
4. Update the kittens name
5. Send _no content_ back to the app

```{ go server.go:update_kitten_handler }
func UpdateKittenHandler(w http.ResponseWriter, r *http.Request){
  vars := mux.Vars(r)
  id, err := strconv.Atoi(vars["id"])
  if err != nil {
    panic(err)
  }

  var kittenJSON KittenJSON
  err = json.NewDecoder(r.Body).Decode(&kittenJSON)
  if err != nil {
    panic(err)
  }
  for index, _ := range kittens {
    if kittens[index].Id == id {
      kittens[index].Name = kittenJSON.Kitten.Name
      break
    }
  }
  w.WriteHeader(http.StatusNoContent)
}
```

## The Circle of Life

In the unfortunate situation where a kitten is to be removed, the following happens

1. The kitten's Id is retreived from the Url
2. The kitten's index in storage is found
3. The kitten storage is rebuilt with the kittens before and after
4. And _no content_ is returned to the application

```{ go server.go:delete_kitten_handler }
func DeleteKittenHandler(w http.ResponseWriter, r *http.Request){
  vars := mux.Vars(r)
  id, err := strconv.Atoi(vars["id"])
  if err != nil {
    panic(err)
  }

  kittenIndex := -1
  for index, _ := range kittens {
    if kittens[index].Id == id{
      kittenIndex = index
      break
    }
  }
  if kittenIndex != -1 {
    kittens = append(kittens[:kittenIndex], kittens[kittenIndex+1:]...)
  }

  w.WriteHeader(http.StatusNoContent)
}
```

## What is a kitten?

A kitten is a struct with an Id, a Name, and a Picture.  Kittens are collected as an array for storage between requests.  When transfering, we have some JSON structs to encapsulte a kitten or collection of kittens that are sent between the app and server.

```{ go server.go:kitten_typedefs }
type Kitten struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Picture string `json:"picture"`
}
var kittens []Kitten

type KittenJSON struct {
  Kitten Kitten `json:"kitten:`
}
type KittensJSON struct {
  Kittens []Kitten `json:"kittens"`
}
```

# Ember Facing, the HTML view

The following is how Ember makes use of the kittens

## Making everything visible: Templates

The page starts by displaying an unamed template.  The template contains an outlet that will be filled based on the router logic we will describe later.  Notice the linkTo statements that will cause navigation to different URLs that will be used to pick the controller used.

```{ html public/index.html:default_template }
<script type="text/x-handlebars">
  <div class="container">
    <ul class="container">
      <li>{{#linkTo "index"}}Index{{/linkTo}}</li>
      <li>{{#linkTo "create"}}Create{{/linkTo}}</li>
    </ul>
    {{outlet}}
  </div>
</script>
```

The following template is the default view.  It creates an unordered list and loops over each kitten in the controller.  Each kitten is then displayed inside a "span3" styled list item and displayed as an image and an H3 containing a name.  It also has a link to edit and a button to delete the kitten.

```{ html public/index.html:index_template }
<script type="text/x-handlebars" data-template-name="index">
  <ul class="thumbnails">
  {{#each controller}}
    <li class="span3">
    <div class="thumbnail">
      <img {{bindAttr src="picture"}}/>
      <div class="caption">
        <h3>{{name}}</h3>
        {{#linkTo "edit" this}}Edit{{/linkTo}}
        <button {{action deleteKitten this}}>Delete</button>
      </div>
    </div>
    <li>
  {{/each}}
</ul>
</script>
```

the creation form makes us of a partial

```{ html public/index.html:create_form }
<script type="text/x-handlebars" data-template-name="create">
  <h1>Create kitten</h1>
  {{partial 'form'}}
</script>
```

The edit form also makes use of the partial

```{ html public/index.html:edit_form }
<script type="text/x-handlebars" data-template-name="edit">
  <h1>Edit kitten</h1>
  {{partial 'form'}}
</script>
```

The partial form specifies the input box and it's source value.  In this case, name.  It also has a submit button.

```{ html public/index.html:form_template }
<script type="text/x-handlebars" data-template-name="_form">
  <form {{action save on="submit"}} class="form-line">
    {{input type="text" value=name}}
    <button type="submit" class="btn btn-primary">Save</button>
  </form>
</script>
```

The templates are laid out in order

```{ html public/index.html:templates }
«default_template»
«form_template»
«create_template»
«edit_template»
«index_template»
```

We use the following scripts.  The app.js is the source code we use.  It's described below.

```{ html public index.html:scripts }
<script src="js/lib/jquery.js"></script>
<script src="js/lib/handlebars.js"></script>
<script src="js/lib/ember.js"></script>
<script src="js/lib/ember-data.js"></script>
<script src="js/app.js"></script>
```

# Ember Embodyment

Ember must know about kittens as well.  Kittens, if you recall, only contain a name and picture URL.

```{ javascript public/js/app.js:model_definition }
App.Kitten = DS.Model.extend({
  name: DS.attr('string'),
  picture: DS.attr('string')
});
```

## Routes

The first thing the user sees is the index.  The index route is defined below.

```{ javascript public/js/app.js:index_route }
App.IndexRoute = Ember.Route.extend({
  mode: function(){
	  return App.Kitten.find();
	},
  events: {
	    «delete_kitten»
 	  }
});
```

the deleteKitten event is triggered in the index template by the handlebars code {{action deleteKitten this}} which sends the deleteKitten event to the current, in this case Index, controller.  The kitten model in question is passed to the event handler and removed from the repository.

```{ javascript public/js/app.js:delete_kitten }
deleteKitten: function(kitten){
		kitten.deleteRecord();
		kitten.save();
              }
```

The other two routes are create and edit.  They are described by the following code.  Notice the URL definition for the edit controller also defines a place where the kitten_id is embedded in the URL.

```{ javascript public/js/app.js:router_definition }
App.Router.map(function(){
  this.route('create');
  this.route('edit', {path: '/edit/:kitten_id'});
});
```
## Staying in control

The create controller handles the saving of a new kitten, navigation to index, and then resets the controller variables to empty.

```{ javascript public/js/app.js:create_controller }
App.CreateController = Ember.Controller.extend({
  name: null,
  save: function(){
    var kitten = App.Kitten.createRecord({
      name: this.get('name')
    ]);
    kitten.save().then(function(){
      this.transitionToRoute('index');
      this.set('name', '');
    }.bind(this));
  }
});
```

The edit controller extens an ObjectController and contains a save function that gets the incoming model, saves it to the store, then navigates to the index route.

```{ javascript public/js/app.js:create_controller }
App.CreateController = Ember.Controller.extend({
  name:null,
  save:function(){
    var kitten = App.Kitten.createRecord({
      name: this.get('name')
    });
    kitten.save().then(function(){
      this.transitionToRoute('index');
    }.bind(this);
  }
});
```

## Storage Wars

The App uses a data store defined in the DS.RESTAdapter

```{ javacsript public/js/app.js:store_definition }
App.Store = DS.Store.extend({
  revision: 13,
  adapter: DS.RESTAdapter.create({
    namespace: 'api'
  })
});
```

# What's not here

I did not include Ember and JQuery.  Those will have to be downloaded yourself.

# Appendix 1. Structure of the go server

```{ go server.go }
package main
import (
  "encoding/json"
  "log"
  "net/http"
  "strconv"
  "github.com/gorilla/mux"
)
«kitten_typedefs»
«update_kitten_handler»
«create_kitten_handler»
«delete_kitten_handler»
«kittens_handler»

func main(){
  log.Println("Starting server")

  kittens = append(kittens, Kitten{Name:"Wallace", Picture:"http://placekitten.com/200/200", Id: 1})

  «router_setup»

  http.Handle("/", http.FileServer(http.Dir("./public/")))

  log.Println("Listening on 8080")
  http.ListenAndServer(":8080", nil)
}
```

# Appendix 2. Structure of the html template

```{ html public/index.html }
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Hello, World!  (Embergo)</title>
    <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css" rel="stylesheet">
  </head>
  <body>
    <h1>Hello, Embergo!</h1>
    «templates»
    «scripts»
  </body>
</html>
```
# Appendix 3. Strucutre of the App.js

```{ javascript public/js/app.js }
(function(){
  var App = Ember.Application.create();
«store_definition»
«router_definition»
«kitten_model»
«index_route»
«create_controller»
«edit_controller»
})();
```
