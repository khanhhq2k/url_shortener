class UrlsController < ApplicationController
  def encode
    original_url = params[:url]
    url = UrlTask::Encoder.new(original_url).call
    return render json: { shortened_link: nil, error_message: 'Invalid request' }, status: 422 unless url
    render json: { shortened_link: build_response_url(url.hash_value) }, status: :ok
  end

  def decode
    original_url = UrlTask::Decoder.new(params[:url]).call
    return render json: { original_link: original_url }, status: :not_found unless original_url

    render json: { original_link: original_url }, status: :ok
  end

  private

  def build_response_url(hash_value)
    "#{request.base_url}/#{hash_value}"
  end

end
