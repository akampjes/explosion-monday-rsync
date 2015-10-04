# explosion-monday-rsync

Create a pair of programs that transfer a file from the server to the client over stdin/stdout.  A file that’s similar to the remote file might exist on the local server already.  The winner will be the correct implementation that transfers a series of supplied files with the fewest bytes.

Usage might look like `./send remote-file.txt | ./recv local-file.txt`

You could even do it over ssh if you have a server: `ssh my-remote-server ./send remote-file.txt | ./recv local-file.txt`

if local-file.txt doesn’t exist, `recv` should create it.  if it does exist, `recv` should use it as a base for the incoming file.

Start by getting `send` and `recv` just transferring the file, ignoring whatever is in local-file.txt.


## Testing

You can run everything by running

`ruby join.rb "ruby send.rb words.txt" "ruby receive.rb"`
