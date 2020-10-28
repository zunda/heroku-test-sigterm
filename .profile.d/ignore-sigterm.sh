ignore()
{
  echo $$: Received a SIGTERM. Ignoring.
}
trap ignore SIGTERM
