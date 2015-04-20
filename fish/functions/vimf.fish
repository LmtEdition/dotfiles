function vimf -d "Open fzf result in vim."
  if fzf > $TMPDIR/fzf.result
    vim (cat $TMPDIR/fzf.result)
  end
end
