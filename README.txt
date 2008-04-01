= Obsidian

http://opensource.thinkrelevance.com

== DESCRIPTION:

Obsidian. It's metastable. 
Chunks of Ruby code we have found helpful.

== FEATURES/PROBLEMS:

=== Model Update Tracker
This library allows you to functionally test updates to models with clearer and more focused intent.
It forces you to have a better understanding of how your Objects interact and let's you demonstrate 
that knowledge by putting it in your tests.  For example instead of writing a test like so

assert_difference Asset :count do
  post :create, :asset => {}
end

you would write your test like so

assert_models_created(Asset) do
  post :create, :asset => {}
end

Now if an asset really created multiple other objects such as an asset owner and a location the above
test would fail stating that it expected more to happen.  This is where you excercise your deep domain
knowledge muscles and make your new obsidian powered test pass.

assert_models_saved(Asset, AssetOwner, Location) do
  post: create, :asset => {}
end

You have just done youself a great service.  If for some reason you change code that affects your 
object model and things fall out of place this test will catch that regression error where the original
assert_difference may not.  There are also a whole host of other methods you can use with model update
tracker that provide functionality for updates, deletes, and no_difference assertions.

* assert_models_created(models)
* assert_models_updated(models)
* assert_models_destroyed(models)
* assert_no_models_created
* assert_no_models_destroyed
* assert_no_models_updated

== INSTALL:

git clone git://github.com/stuarthalloway/obsidian.git
rake gem
sudo gem install pkg/#{pkg_name}

== LICENSE:

(The MIT License)

Copyright (c) 2008 Relevance, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
