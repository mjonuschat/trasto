# Trasto

[![Build Status](https://secure.travis-ci.org/yabawock/trasto.png)](http://travis-ci.org/yabawock/trasto)

Translatable columns for Rails 3, directly stored in a postgres hstore in the model table.

Inspired by Barsoom's [traco](https://github.com/barsoom/traco/).

To store translations outside the model, see Sven Fuchs' [globalize3](https://github.com/svenfuchs/globalize3).

## Usage

Say you want `Post#title` and `Post#body` to support both English and Swedish values.

Write a migration to get hstore database columns with i18n suffixes, e.g. `title_i18n` and `body_i18n`, like:

    class CreatePosts < ActiveRecord::Migration
      def change
        create_table :posts do |t|
          t.hstore :title_i18n
          t.hstore :body_i18n

          t.timestamps
        end
      end
    end

Don't create `title` or `body` columns without the `_i18n` suffix, Trasto will define a method with that name.

Declare these columns in the model:

    class Post < ActiveRecord::Base
      translates :title, :body
    end

You can still use your accessors for `title_i18n` and `title_i18=` in forms, validations and other code, but you also get:

`#title`:  Shows the title in the current locale. If blank, falls back to default locale, then to any locale.

`#title=`: Assigns the title to the column for the current locale, if present.

`.locales_for_column(:title)`: Returns an array like `[:de, :en]` sorted with default locale first and then all currently available locals sorted alphabetically.

## Installation

Add this to your `Gemfile` if you use Bundler 1.1+:

    gem 'traco'

Then run

    bundle install

to install it.


## Running the tests

    bundle
    rake

## Credits and license

By [Morton Jonuschat](https://github.com/yabawock) under the MIT license:

>  Copyright (c) 2012 Morton Jonuschat
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
