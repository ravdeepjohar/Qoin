function descriptor_template = make_descriptor_template(template_names)
descriptor_template = cell(1,length(template_names));
for k = 1:length(template_names)
    img = imread(template_names{k});
    [F D] = get_descriptors(img);
    descriptor_template{k} = D;
end