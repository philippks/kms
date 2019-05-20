module IconsHelper
  def fa_icon(icon, title: nil)
    content_tag(:i, '', class: "fa fa-#{icon}", title: title)
  end

  def tooltip_icon_for(
    *lines, title: nil, fa_icon: 'envelope', position: 'left'
  )
    return '' if lines.flatten.empty?
    joined_lines = safe_join([title].compact + lines, '&#10;'.html_safe)
    content_tag(
      :a,
      '',
      href: '#',
      class: 'tooltip_icon',
      data: {
        balloon: joined_lines, 'balloon-pos' => position, 'balloon-break' => ''
      }
    ) { content_tag(:i, '', class: "fa fa-#{fa_icon} tooltip_icon") }
  end
end
