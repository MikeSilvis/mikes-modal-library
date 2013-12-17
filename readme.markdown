# Mike's Modal Library
Mike's Modal Library is a Facebook-like photo library written to support photos and comments on an individual photo.

[Example gallery](http://mikesilvis.github.com/mikes-modal-library/)

A special thanks to [fgnass](https://github.com/fgnass) for the [spin.js library](https://github.com/fgnass/spin.js/)

## Example Sites
- [Auxotic](http://auxotic.com)

## Usage

1) Download the JavaScript file and stylesheet, and include them.
```html
<link type="text/css" rel="stylesheet" media="all" href="https://raw.github.com/MikeSilvis/mikes-modal-library/master/lib/mikes-modal.css">
<script src="http://raw.github.com/MikeSilvis/mikes-modal-library/master/lib/mikes-modal.min.js" type="text/javascript"></script>
```

2) Create a div on your page with the class .mikes-modal
```html
<div class="mikes-modal" id="myModal">
  <img src='http://s3.amazonaws.com/ultimate_whip/garage_photos/photos/000/000/079/large/38779594009_original.jpeg?1349826286'>
  <div class="description">
    <h1>Title of Modal</h1>
    <p>Put whatever content you need here. I personally used it for comments and tags :)</p>
  </div>
</div>
```
3) Add a button, link, image or whatever you need to open the modal.
```html
<a id="open-mikes-modal" class="btn btn-primary btn-large">Try it now!</a>
```
4) Add a jQuery callback when you click the button
```javascript
jQuery(function() {
  $("#open-mikes-modal").click(function(e) {
      $("#myModal").mikesModal();
  });
});
```
## Helpers
For custom functions you can bind / trigger the following manually:
```javascript
  $("#myModal").trigger("open");
  $("#myModal").trigger("close");
  $("#myModal").bind("open", function() {
    myCustomFunction();
  });

```

## Contributing

1. Fork it.
2. Create a branch (`git checkout -b my_awesome_branch`)
3. Edit the files in the src folder ONLY
4. run cake build *note* you may need to run `npm install snockets`
5. Commit your changes (`git commit -am "Added some magic"`)
6. Push to the branch (`git push origin my_awesome_branch`)
7. Send a pull request

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
