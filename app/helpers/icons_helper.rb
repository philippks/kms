module IconsHelper
  def fa_icon(icon, title: nil)
    content_tag(:i, '', class: "fa fa-#{icon}", title:)
  end

  def tooltip_icon_for(*lines, title:, fa_icon: 'envelope', position: 'left')
    return '' if lines.flatten.empty?

    joined_lines = safe_join([title] + lines, '&#10;'.html_safe)
    content_tag(:a, '', href: '#',
                        class: 'tooltip_icon',
                        data: {
                          balloon: joined_lines,
                          'balloon-pos' => position,
                          'balloon-break' => '',
                        }) do
      content_tag(:i, '', class: "fa fa-#{fa_icon} tooltip_icon")
    end
  end
end
