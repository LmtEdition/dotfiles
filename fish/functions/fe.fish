function fe -d "Open fzf result in vim."
  set tmp $TMPDIR/fzf.result
  fzf --query="$argv[1]" --select-1 --exit-0 > $tmp
  if [ (cat $tmp | wc -l) -gt 0 ]
    vim (cat $tmp)
  end
end
