-- Promote paragraphs that are only <strong>...</strong> to Heading 3
function Para(el)
  if #el.content == 1 and el.content[1].t == 'Strong' then
    return pandoc.Header(3, el.content[1])
  end
end
