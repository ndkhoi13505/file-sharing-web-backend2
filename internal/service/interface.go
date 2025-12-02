package service

import (
	"context"
	"mime/multipart"

	"github.com/dath-251-thuanle/file-sharing-web-backend2/config"
	"github.com/dath-251-thuanle/file-sharing-web-backend2/internal/api/dto"
	"github.com/dath-251-thuanle/file-sharing-web-backend2/internal/domain"
	"github.com/gin-gonic/gin"
)

type TOTPSetupResponse struct {
	Secret string `json:"secret"`
	QRCode string `json:"qrCode"`
}

type UserService interface {
	GetUserById(id string) (*domain.User, error)
	GetUserByEmail(email string) (*domain.UserResponse, error)
}

type AuthService interface {
	CreateUser(username, password, email string) (*domain.User, error)
	Login(email, password string) (user *domain.User, accessToken string, err error)
	SetupTOTP(userID string) (*TOTPSetupResponse, error)
	VerifyTOTP(userID string, code string) (bool, error)
	Logout(ctx *gin.Context) error
	LoginTOTP(email, totpCode string) (*domain.User, string, error)
}

type FileService interface {
	UploadFile(ctx context.Context, fileHeader *multipart.FileHeader, req *dto.UploadRequest, ownerID *string) (*domain.File, error)
	GetMyFiles(ctx context.Context, userID string, params domain.ListFileParams) (interface{}, error)
	DeleteFile(ctx context.Context, fileID string, userID string) error
	GetFileInfo(ctx context.Context, token string, userID string) (*domain.File, error)
	GetFileInfoID(ctx context.Context, token string, userID string) (*domain.File, error)
	DownloadFile(ctx context.Context, token string, userID string, password string) (*domain.File, []byte, error)
	GetFileDownloadHistory(ctx context.Context, fileID string, userID string, pagenum, limit int) (*domain.FileDownloadHistory, error)
}

type AdminService interface {
	GetSystemPolicy(ctx context.Context) (*config.SystemPolicy, error)
	UpdateSystemPolicy(ctx context.Context, updates map[string]any) (*config.SystemPolicy, error)
	CleanupExpiredFiles(ctx context.Context) (int, error)
}
