package openai

import (
	"context"
	"fmt"
	"io"
	"net/http"

	"github.com/mynaparrot/plugnmeet-protocol/plugnmeet"
	"github.com/mynaparrot/plugnmeet-server/pkg/config"
	"github.com/mynaparrot/plugnmeet-server/pkg/insights"
	"github.com/sirupsen/logrus"
)

type OpenAIProvider struct {
	apiKey  string
	baseURL string
	client  *http.Client
	logger  *logrus.Entry
}

func NewProvider(providerAccount *config.ProviderAccount, serviceConfig *config.ServiceConfig, log *logrus.Entry) (insights.Provider, error) {
	if providerAccount.Credentials.APIKey == "" {
		return nil, fmt.Errorf("openai provider requires api_key")
	}

	baseURL := "https://api.openai.com/v1"
	if providerAccount.Credentials.BaseURL != "" {
		baseURL = providerAccount.Credentials.BaseURL
	}

	return &OpenAIProvider{
		apiKey:  providerAccount.Credentials.APIKey,
		baseURL: baseURL,
		client:  &http.Client{},
		logger:  log,
	}, nil
}

func (p *OpenAIProvider) AITextChatStream(ctx context.Context, chatModel string, history []*plugnmeet.InsightsAITextChatContent) (<-chan *plugnmeet.InsightsAITextChatStreamResult, error) {
	return newChatStream(ctx, p, chatModel, history)
}

func (p *OpenAIProvider) AIChatTextSummarize(ctx context.Context, summarizeModel string, history []*plugnmeet.InsightsAITextChatContent) (string, uint32, uint32, error) {
	return summarize(ctx, p, summarizeModel, history)
}

func (p *OpenAIProvider) CreateTranscription(ctx context.Context, roomId, userId string, options []byte) (insights.TranscriptionStream, error) {
	return nil, fmt.Errorf("CreateTranscription is not implemented for the openai provider")
}

func (p *OpenAIProvider) TranslateText(ctx context.Context, text, sourceLang string, targetLangs []string) (*plugnmeet.InsightsTextTranslationResult, error) {
	return nil, fmt.Errorf("TranslateText is not implemented for the openai provider")
}

func (p *OpenAIProvider) SynthesizeText(ctx context.Context, options []byte) (io.ReadCloser, error) {
	return nil, fmt.Errorf("SynthesizeText is not implemented for the openai provider")
}

func (p *OpenAIProvider) GetSupportedLanguages(serviceType insights.ServiceType) []*plugnmeet.InsightsSupportedLangInfo {
	return nil
}
