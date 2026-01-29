# Shell Functions

BLOG_PATH=~/Development/cuento-blog

blist ()
{
  # Takes a url and adds it to my reading list post inside of the cuento-blog repo.
  # Usage: blist <url>
  # Example: blist https://example.com/some-interesting-article

  if [ -z "$1" ]; then
    echo "Usage: blist <url>"
    return 1
  fi

  local url="$1"

  local title=$(curl -s "$url" | grep -o '<title>[^<]*' | sed 's/<title>//')
  if [ -z "$title" ]; then
    echo "Could not retrieve title from the URL."
  fi

  # Append the url and title in a list in the markdown file
  echo "\n - [$title]($url)" >> $BLOG_PATH//content/posts/reading-list.md
}

post ()
{
  # Takes a title and creates a new markdown file in the posts directory.
  # Usage: post <title>
  # Example: post "My New Post"

  local title="$1"
  local summary="$2"


  if [[ -z "$title" ]]; then
    echo "Error: Title is required." >&2
    echo "Usage: create_note <title> [summary]" >&2
    return 1
  fi

  if [[ -n "$summary" ]]; then
    echo "Summary: $summary"
  else
    echo "No summary provided."
  fi

  echo "Creating note..."
  echo "Title: $title"

  local slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  local date=$(date +%Y-%m-%d)
  local filename="content/posts/${date}-${slug}.md"

  echo "Creating file: $filename"

  # create the file
  touch $BLOG_PATH/$filename
  echo "---" > $BLOG_PATH/$filename
  echo "title: \"$title\"" >> $BLOG_PATH/$filename
  echo "date: $date" >> $BLOG_PATH/$filename
  echo "draft: true" >> $BLOG_PATH/$filename
  echo "tags: []" >> $BLOG_PATH/$filename
  echo "summary: $summary" >> $BLOG_PATH/$filename
  echo "author: 'Matt Cuento'" >> $BLOG_PATH/$filename
  echo "---" >> $BLOG_PATH/$filename
}
