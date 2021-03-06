defmodule Decoction.ImageUpload do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(version, {file, scope}) do
    "uploads/images/"
  end

  def filename(version, {file, scope}) do
    "#{UUID.uuid5(:nil, file.file_name)}"
  end

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end
end
