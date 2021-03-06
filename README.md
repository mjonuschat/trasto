# Trasto

[![Build Status](https://secure.travis-ci.org/mjonuschat/trasto.png)](https://travis-ci.org/mjonuschat/trasto)

Translatable columns for Rails 4, directly stored in a postgres hstore in the model table.

Inspired by Barsoom's [traco](https://github.com/barsoom/traco/).

To store translations outside the model, see Sven Fuchs' [globalize3](https://github.com/svenfuchs/globalize3).

## Usage

Say you want `Post#title` and `Post#body` to support both English and Swedish values.

Write a migration to get hstore database columns with i18n suffixes, e.g. `title_i18n` and `body_i18n`, like:

```ruby
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.hstore :title_i18n
      t.hstore :body_i18n

      t.timestamps
    end
  end
end
```

Don't create `title` or `body` columns without the `_i18n` suffix, Trasto will define a method with that name.

Declare these columns in the model:

```ruby
class Post < ActiveRecord::Base
  translates :title, :body
end
```

You can still use your accessors for `title_i18n` and `title_i18=` in forms, validations and other code, but you also get:

`#title`:  Shows the title in the current locale. If blank, falls back to default locale, then to any locale.

`#title=`: Assigns the title to the column for the current locale, if present.

`.locales_for_column(:title)`: Returns an array like `[:de, :en]` sorted with default locale first and then all currently available locals sorted alphabetically.

## Installation

Add this to your `Gemfile`:

```ruby
  gem 'trasto'
```

You might need to enable the hstore extension for your database. Create a migration containing the necessary instruction:

```ruby
class EnableHstore < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
  end
end
```

## Running the tests

```
    bundle exec appraisal install
    bundle exec appraisal rake
```

To run only one appraisal/gemfile:

```
bundle exec appraisal 4.2 rake
```

## Credits and license

By [Morton Jonuschat](https://github.com/yabawock) under the MIT license:

>  Copyright (c) 2012-2015 Morton Jonuschat
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
